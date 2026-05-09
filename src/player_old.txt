

-- this file contains the logic for the player character

-- initialize player
function new_player(number,role)
    local x=140+8*number
    local y=205
    local frame=0
    local number=number
    local role=role
    local is={
        moving={up,down,left,right},
        shooting=false,
        drilling=false,
        mining=false,
        rns=false}
    local was_mining=false
    local drills_damage=4
    local mining_damage=10
    local playing_sound_of={drill=false,gun=false}
    local points=0
    local max_ammo=role=="gunner" and 100 or 25
    local ammo=max_ammo
    local max_fuel=role=="driller" and 250 or 0
    local fuel=max_fuel
    local health=3
    local max_health=3
    local mining_since=60
    local mining_delay=10
    local hit_since=60
    local shot_since=60
    local shot_delay=role=="gunner" and 1 or 3
    local collision_points={left={},right={},top={}}
    local has_collision={left=false,right=false,top=false}
    for i=1,8 do
        add(collision_points.left,{x=0,y=0})
        add(collision_points.right,{x=0,y=0})
        add(collision_points.top,{x=0,y=0})
    end

    -- checks inputs and writes them to the state of the player
    -- can be done for both players
    local function fetch_inputs()
        local p=number-1
        is.shooting=btn(5,p) and not btn(4,p)
        if role=="gunner" and is.shooting then
            is.moving.up=false
            is.moving.left=false
            is.moving.right=false
            -- move down if playing, else stay in place
            is.moving.down=playing
        else
            is.moving.up=btn(2,p)
            is.moving.down=btn(3,p)
            is.moving.left=btn(0,p)
            is.moving.right=btn(1,p)
        end
        -- CURRENTLY YOU CANNOT ROCK AND STONE
        is.rns=btn(3,p) and btn(4,p) and btn(5,p)
        -- determine if mining or drilling
        if btn(4,p) and not btn(5,p) then
            is.drilling=fuel>0
            is.mining=not is.drilling
        else
            is.drilling=false
            is.mining=false
        end
    end

    local function update_player_collision_points()
        -- left flank
        for i=1,6 do
            collision_points.left[i].x=x
            collision_points.left[i].y=y+i
        end
        -- right flank
        for i=1,6 do
            collision_points.right[i].x=x+7
            collision_points.right[i].y=y+i
        end
        -- top flank
        for i=1,6 do
            collision_points.top[i].x=x+i
            collision_points.top[i].y=y-1
        end
    end

    local function find_terrain_collision()
        local point,color
        has_collision.left=false
        has_collision.right=false
        has_collision.top=false
        for i=1,#collision_points.left do
            point=collision_points.left[i]
            color=pget(point.x,point.y)
            if color==5 or color==13 then
                has_collision.left=true
                break
            end
        end
        for i=1,#collision_points.right do
            point=collision_points.right[i]
            color=pget(point.x,point.y)
            if color==5 or color==13 then
                has_collision.right=true
                break
            end
        end
        for i=1,#collision_points.top do
            point=collision_points.top[i]
            color=pget(point.x,point.y)
            if color==5 or color==13 then
                has_collision.top=true
                break
            end
        end
    end

    -- places mined ground under the player, even though
    -- "drilled_ground" is called
    local function mine()
        if mining_since>mining_delay then
            map.add_drilled_ground(53,x,y-2)
            sfx(-1,number)
            sfx(31,number)
            mining_since=0
        end
    end

    local function drill()
        if fuel>0 then
            map.add_drilled_ground(52,x,y-2)
            fuel-=1
            if not playing_sound_of.drill then
                sfx(-1,number)
                sfx(30,number)
                playing_sound_of.drill=true
            end
        end
    end

    local function shoot()
        if shot_since>shot_delay then
            if ammo>0 then
                projectiles.fire_bullet(number)
                ammo-=1
                if role=="gunner" and not playing_sound_of.gun then
                    sfx(36,number)
                    playing_sound_of.gun=true
                elseif role=="driller" or role=="engineer" then
                    sfx(34,number)
                end
            else
                sfx(35,number)
            end
            shot_since=0
        end
    end

    -- give ammo based on max capacity and cap it
    local function give_ammo(percentage)
        ammo=min(ammo+max_ammo*percentage,max_ammo)
        fuel=min(fuel+max_fuel*percentage,max_fuel)
    end

    -- move the player normally, except if a gunner is currently shooting,
    -- then move with half the speed
    local function move_player()
        if is.moving.up and not has_collision.top then
            if y>102 then
                y-=1
            end
        end
        if is.moving.down then
            if y<221 then
                y+=1
            end
        end
        if is.moving.left and not has_collision.left then
            if x>=102 then
                x-=1
            end
        end
        if is.moving.right and not has_collision.right then
            if x<=220 then
                x+=1
            end
        end
        if has_collision.top and playing then
            y+=1
        end
        if y<=102 then y=102 end
        if y>=221 then y=221 end
    end

    -- handles moving the player around
    local function update()
        fetch_inputs()
        update_player_collision_points()
        find_terrain_collision()
        move_player()
        if is.drilling then
            drill()
        elseif playing_sound_of.drill then
            sfx(-1,number)
            playing_sound_of.drill=false
        end
        if is.mining then mine() end
        if is.shooting then
            shoot()
        elseif playing_sound_of.gun then
            sfx(-1,number)
            playing_sound_of.gun=false
        end
        mining_since=min(mining_since+1,1000)
        shot_since=min(shot_since+1,1000)
        hit_since=min(hit_since+1,1000)
    end

    local function damage_player(amount)
        if hit_since>30 then
            health-=amount
            sfx(32,number)
            hit_since=0
        end
    end

    local function draw_gun()
        pset(x+6,y,6)
        pset(x+6,y+1,6)
        if role=="gunner" then
            pset(x+5,y,6)
            pset(x+7,y,6)
            pset(x+7,y+1,6)
            pset(x+7,y+2,6)
            pset(x+7,y+3,6)
            pset(x+7,y+4,6)
        end
    end

    local function draw_drills()
        pset(x+6,y,5)
        pset(x+6,y+1,5)
        pset(x+5,y,5)
        pset(x+2,y,5)
        pset(x+1,y,5)
        pset(x+1,y+1,5)
    end

    local function draw_pickaxe()
        pset(x+6,y,5)
        pset(x+6,y+1,4)
        pset(x+6,y+2,4)
    end

    local function change_role(new_role)
        role=new_role
        max_ammo=role=="gunner" and 100 or 25
        ammo=max_ammo
        max_fuel=role=="driller" and 250 or 0
        fuel=max_fuel
        shot_delay=role=="gunner" and 1 or 3
        local role_ids={driller=1,gunner=2,engineer=3}
        dset(10+number,role_ids[role])
    end

    -- draws player based on current state
    local function draw()
        local moving,x_flip
        local speed=1
        if playing then
            moving=(not is.moving.down
                or is.moving.left or is.moving.right)
            if playing and is.moving.up then speed=2 end

        -- only run if in playing mode, otherwise just default
        elseif at_title_screen then
            moving=(is.moving.down or is.moving.up
                or is.moving.left or is.moving.right)
        end
        local sprite=role=="driller" and 48 or 32
        if role=="engineer" then sprite=34 end

        -- determine how fast legs should switch

        if moving then sprite+=1 end

        x_flip=frame>=8
        frame=(frame+speed)%16

        if hit_since<=30 then
            pal(10,2)
            pal(3,2)
            pal(8,2)
        end
        spr(sprite,x,y,1,1,x_flip,false)
        pal()
        if is.shooting then draw_gun() end
        if is.drilling then draw_drills() end
        if mining_since<mining_delay*.7 then draw_pickaxe() end
    end

    return {
        -- default functions
        update=update,
        draw=draw,
        damage=damage_player,
        give_ammo=give_ammo,
        change_role=change_role,

        -- inline functions
        give_points=function(amount) points+=amount end,
        give_health=function(amount) health=min(health+amount,max_health) end,
        get_hitbox=function() return {x={x+1,x+6},y={y,y+7}} end,
        get_mining_hitbox=function() return {x={x,x+7},y={y-1,y+3}} end,
        get_damaging_hitbox=function() return {x={x,x+7},y={y-3,y+3}} end,
        reposition=function(x_new, y_new) x=x_new;y=y_new end,

        -- getters
        x=function() return x end,
        y=function() return y end,
        is_drilling=function() return is.drilling end,
        is_shooting=function() return is.shooting end,
        is_mining=function() return mining_since<2 end,
        get_role=function() return role end,
        is_rns=function() return is.rns end,
        health=function() return health end,
        number=function() return number end,
        ammo=function() return ammo end,
        fuel=function() return fuel end,
        points=function() return points end,
        max_ammo=function() return max_ammo end,
        max_fuel=function() return max_fuel end,
        drills_damage=drills_damage,
        mining_damage=mining_damage,
    }
end


