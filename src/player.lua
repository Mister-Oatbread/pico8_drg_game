

-- this file contains the logic for the player character

-- initialize player
function new_player(number,role)
    local max_ammo,max_fuel,fuel,ammo,shot_delay
    local role_numbers={["driller"]=1,["gunner"]=2,["engineer"]=3}
    -- local role_numbers={driller=1,gunner=2,engineer=3}

-- INIT START
    local function change_role(new_role)
        role=new_role
        max_ammo=role=="gunner" and 100 or 25
        ammo=max_ammo
        max_fuel=role=="driller" and 250 or 0
        fuel=max_fuel
        shot_delay=role=="gunner" and 1 or 3
        dset(10+number,role_numbers[role])
    end

    local points=0
    local x=140+8*number
    local y=205
    local frame=0
    local number=number
    local role=role

    local is_walking=false
    local is_moving_right=false
    local is_moving_left=false
    local is_sprinting=false
    local is_standing=true
    local is_crawling=false

    local is_mining=false
    local is_drilling=false
    local is_shooting=false
    local mining_since=30
    local mining_delay=3
    local shot_since=30
    local mining_damage=10
    local drills_damage=4

    change_role(role)
    local max_health=3
    local health=max_health
    local hit_since=60

    local collision_points_left={}
    local collision_points_right={}
    local collision_points_top={}
    local no_collision_left=false
    local no_collision_right=false
    local no_collision_top=false

    for i=1,6 do
        add(collision_points_left,{x=0,y=0})
        add(collision_points_right,{x=0,y=0})
        add(collision_points_top,{x=0,y=0})
    end

-- INIT END

-- UPDATE START
    -- check what player is currently doing
    local function fetch_inputs()
        local p=number-1

        is_moving_left=btn(0,p)
        is_moving_right=btn(1,p)
        is_moving_up=not btn(3,p) and (
            not btn(2,p) and playing or btn(2,p) and at_title_screen
        )
        is_moving_down=not btn(2,p) and btn(3,p) and at_title_screen
        is_sprinting=btn(2,p) and not btn(3,p) and playing
        is_standing=(
            playing and btn(3,p)
        ) or (
            at_title_screen and not (btn(3,p) or btn(2,p))
        )
        is_drilling=btn(4,p) and not btn(5,p) and fuel>0
        is_mining=btn(4,p) and not btn(5,p) and fuel==0
        is_shooting=btn(5,p) and not btn(4,p)
        is_crawling=role=="gunner" and is_shooting
    end

    local function find_terrain_collision()
        -- update collision point positions
        -- left flank
        for i=1,6 do
            collision_points_left[i].x=x
            collision_points_left[i].y=y+i
        end
        -- right flank
        for i=1,6 do
            collision_points_right[i].x=x+7
            collision_points_right[i].y=y+i
        end
        -- top flank
        for i=1,6 do
            collision_points_top[i].x=x+i
            collision_points_top[i].y=y-1
        end

        -- check if any direction has a collision
        local function check_if_clear(collision_points)
            local color
            for i=1,#collision_points do
                color=pget(collision_points[i].x, collision_points[i].y)
                if color==5 or color==13 then
                    return false
                end
            end
            return true
        end
        no_collision_left=check_if_clear(collision_points_left)
        no_collision_right=check_if_clear(collision_points_right)
        no_collision_top=check_if_clear(collision_points_top)
    end

    local function update_position()
        if is_moving_left and no_collision_left then x-=1 end
        if is_moving_right and no_collision_right then x+=1 end
        if playing then
            if is_standing then y+=1 end
            if is_sprinting and no_collision_top then y-=1 end
        elseif at_title_screen then
            if is_moving_up and no_collision_top then y-=1 end
            if is_moving_down then y+=1 end
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

    -- give ammo based on max capacity and cap it
    local function give_resources(percentage)
        ammo=min(ammo+max_ammo*percentage,max_ammo)
        fuel=min(fuel+max_fuel*percentage,max_fuel)
    end

    local function damage_player(amount)
        if hit_since>30 then
            health-=amount
            sfx(32,number)
            hit_since=0
        end
    end
-- UPDATE END

-- DRAW START
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
-- DRAW END

    local function update()
        fetch_inputs()
        find_terrain_collision()
        update_position()

        if is_drilling then drill() end
        if is_shooting then shoot() end
        if is_mining then mine() end
        shot_since+=1
        mining_since+=1
    end

    local function draw()
        local x_flip
        local sprite=role=="driller" and 48 or role=="gunner" and 32 or 34

        -- determine how fast legs should switch
        frame=(frame+1)%16

        if is_sprinting then
            x_flip=frame>8
        elseif is_sprinting then
            x_flip=frame%2>4
        end
        if hit_since<=30 then
            pal(10,2)
            pal(3,2)
            pal(8,2)
        end
        spr(sprite,x,y,1,1,x_flip,false)
        pal()
        if is_shooting then draw_gun() end
        if is_drilling then draw_drills() end
        if mining_since<mining_delay*.7 then draw_pickaxe() end
    end

    return {
        update=update,
        draw=draw,

        change_role=change_role,
        give_resources=give_resources,
        damage_player=damage_player,

        -- getters
        x=function() return x end,
        y=function() return y end,
        get_hitbox=function() return {x={x+1,x+6},y={y,y+7}} end,
        is_drilling=function() return is_drilling end,
        is_shooting=function() return is_shooting end,
        is_mining=function() return mining_since<2 end,
        get_role=function() return role end,
        -- is_rns=function() return is_rns end,
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


