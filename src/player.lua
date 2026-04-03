

-- this file contains the logic for the player character

-- initialize player
function new_player(number,role)
    local x=148
    local y=200
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
    local mined_since=0
    local playing={drill_sound=false,gun_sound=false}
    local moving_frame=0
    local points=0
    local ammo=role=="driller" and 25 or 100
    local fuel=role=="driller" and 150 or 0
    local max_ammo=role=="driller" and 25 or 100
    local max_fuel=role=="driller" and 150 or 0
    local shots_fired=false
    local shot_delay_counter=0
    local max_shot_delay=role=="driller" and 3 or 1
    local health=3
    local max_health=3
    local is_hit=false
    local hit_since=0
    local has_invuln=false
    local invuln_duration=30
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
        is.moving.up=btn(2,p)
        is.moving.down=btn(3,p)
        is.moving.left=btn(0,p)
        is.moving.right=btn(1,p)
        is.shooting=btn(5,p) and not btn(4,p)
        local drilling_button=btn(4,p) and not btn(5,p)
        is.rns=btn(3,p) and btn(4,p) and btn(5,p)

        is.drilling=drilling_button and fuel>0
        local mining_button=drilling_button and fuel<=0
        -- check if we are currently mining or drilling,
        -- since both go over one button
        is.mining=mining_button and not was_mining
        if is.mining then mined_since=0 end
        was_mining=mining_button or mined_since<5
        mined_since+=1
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
        map.spawn_drilled_ground(53,x,y-2)
        sfx(-1,number)
        sfx(31,number)
    end

    local function drill()
        if fuel>0 then
            map.spawn_drilled_ground(52,x,y-2)
            fuel-=1
            if not playing.drill_sound then
                sfx(-1,number)
                sfx(30,number)
                playing.drill_sound=true
            end
            -- local drill_box=get_damaging_drills_hitbox()
            -- local creature_box,creature
            -- -- drill creatures
            -- for i=#creatures,1,-1 do
            --     creature=creatures[i]
            --     creature_box=get_creature_hitbox(creature)
            --     if are_colliding(creature_box,drill_box) then
            --         creature.damage(4)
            --     end
            -- end
        end
    end

    local function shoot()
        if ammo > 0 then
            projectiles.fire_bullet(number)
            ammo-=1
            if role=="gunner" and not playing.gun_sound then
                sfx(-1,number)
                sfx(36,number)
                playing.gun_sound=true
            elseif role=="driller" then
                sfx(-1,number)
                sfx(34,number)
            end

        else
            sfx(-1,number)
            sfx(35,number)
        end
        shots_fired=true
    end

    -- give ammo based on max capacity and cap it
    local function give_ammo(percentage)
        ammo+=ceil(max_ammo*percentage)
        fuel+=ceil(max_fuel*percentage)

        if ammo>max_ammo then ammo=max_ammo end
        if fuel>max_fuel then fuel=max_fuel end
    end

    -- give player amount of health and cap it
    local function give_health(amount)
        health+=amount
        if health>max_health then health=max_health end
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
        if has_collision.top then
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
        else
            if playing.drill_sound then
                sfx(-1,number)
                playing.drill_sound=false
            end
        end
        if is.mining then mine() end

        -- shot was recently fired, don't fire again
        if shots_fired and shot_delay_counter<max_shot_delay then
            shot_delay_counter+=1
        else
            -- didn't shoot recently, check if player is firing
            shots_fired=false
            shot_delay_counter=0
            if is.shooting then
                shoot()
            else
                if playing.gun_sound then
                    sfx(-1,number)
                    playing.gun_sound=false
                end
            end
        end
    end

    -- takes in player and returns hitbox ready to be processed by
    -- are_colliding()
    local function get_hitbox()
        return {
            x={x+1,x+6},
            y={y,y+7},
        };
    end

    -- takes in player and returns hitbox ready to be processed by
    -- are_colliding(), but for the drills instead of the player
    local function get_drills_hitbox()
        return {
            x={x,x+7},
            y={y-1,y+3},
        };
    end

    -- hitbox for hitting creatures
    local function get_damaging_drills_hitbox()
        return {
            x={x,x+7},
            y={y-3,y+3},
        };
    end


    local function handle_being_hit()
        if player.is_hit and player.hit_since>player.invuln_duration then
            player.hit_since = 0
            player.is_hit = false
            player.has_invuln = false
        elseif player.is_hit and player.hit_since<=player.invuln_duration then
            player.hit_since+=1
        end

        if player.is_hit and player.hit_since == 1 then
            sfx(32)
        end

        if player.health <= 0 then game_status = "end_screen" end
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

    -- draws player based on current state
    local function draw()
        local moving,x_flip
        if game_status=="playing" then
            moving=(not is.moving.down
                or is.moving.left or is.moving.right)
        -- only run if in playing mode, otherwise just default
        elseif game_status=="title_screen" then
            moving=(is.moving.down or is.moving.up
                or is.moving.left or is.moving.right)
        end
        local sprite=role=="driller" and 48 or 32
        local speed=1
        if game_status=="playing" and is.moving.up then speed=2 end

        if moving then sprite+=1 end

        x_flip=moving_frame>=8
        moving_frame=(moving_frame+speed)%16

        if is_hit then pal(8,10) end
        spr(sprite,x,y,1,1,x_flip,false)
        pal()
        if is.shooting then draw_gun() end
        if is.drilling then draw_drills() end
        if is.mining or was_mining then draw_pickaxe() end
    end

    local function x_f() return x end
    local function y_f() return y end
    local function drilling_f() return is.drilling or is.mining end
    local function shooting_f() return is.shooting end
    local function rns_f() return is.rns end
    local function hit_f() return is_hit end
    local function health_f() return health end
    local function ammo_f() return ammo end
    local function fuel_f() return fuel end
    local function points_f() return points end
    local function change_role(role) role=role end
    local function give_points(amount) points+=amount end

    return {
        x=x_f,
        y=y_f,
        update=update,
        draw=draw,
        give_ammo=give_ammo,
        give_health=give_health,
        give_points=give_points,
        get_hitbox=get_hitbox,
        get_drills_hitbox=get_drills_hitbox,
        get_damaging_drills_hitbox=get_damaging_drills_hitbox,
        is_drilling=drilling_f,
        is_shooting=shooting_f,
        is_rns=rns_f,
        is_hit=hit_f,
        health=health_f,
        number=number,
        ammo=ammo_f,
        fuel=fuel_f,
        points=points_f,
        change_role=change_role,
        max_ammo=max_ammo,
        max_fuel=max_fuel,
        drills_damage=drills_damage,
    }
end


