

-- this file contains the logic for the player character

-- initialize player
function new_player()
    local x=148
    local y=200
    local is={
        moving={up,down,left,right},
        shooting=false,
        drilling=false,
        rns=false}
    local playing_drill={empty=false,full=false}
    local moving_frame=0
    local use_alt_sprite=false
    local x_flip=false
    local ammo=25
    local fuel=150
    local max_ammo=25
    local max_fuel=150
    local shots_fired=false
    local shot_delay_counter=0
    local max_shot_delay=3
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
    local function fetch_inputs()
        is.moving.up=btn(2)
        is.moving.down=btn(3)
        is.moving.left=btn(0)
        is.moving.right=btn(1)
        is.shooting=btn(5) and not btn(4)
        is.drilling=btn(4) and not btn(5)
        is.rns=btn(3) and btn(4) and btn(5)
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

    local function drill()
        local sound
        if (fuel>0) then
            drilled_ground.spawn(x,y-1)
            fuel-=1
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
            projectiles.fire_bullet()
            ammo-=1
            sfx(-1,2)
            sfx(34,2)
        else
            sfx(-1,2)
            sfx(35,2)
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
        if is.drilling then drill() end

        -- shot was recently fired, don't fire again
        if shots_fired and shot_delay_counter<max_shot_delay then
            shot_delay_counter+=1
        else
            -- didn't shoot recently, check if player is firing
            shots_fired=false
            shot_delay_counter=0
            if is.shooting then shoot() end
        end
    end

    -- takes in player and returns hitbox ready to be processed by are_colliding()
    local function get_hitbox()
        return {
            x={x+1,x+6},
            y={y,y+7},
        };
    end

    -- takes in player and returns hitbox ready to be processed by are_colliding()
    -- but for the drills instead of the player
    function get_drills_hitbox()
        return {
            x={x,x+7},
            y={y-1,y+3},
        };
    end

    -- hitbox for hitting creatures
    function get_damaging_drills_hitbox()
        return {
            x={x,x+7},
            y={y-3,y+3},
        };
    end

    -- checks if any hostile creature is currently touching the player
    local function check_if_hit_by_creature()
        local player_box = get_player_hitbox(player)
        local creature_box
        local no_creatures = #creatures

        if no_creatures>0 and not player.is_drilling then
            for i=1,no_creatures do
                creature_box = get_creature_hitbox(creatures[i])
                if are_colliding(player_box, creature_box) then
                    if creatures[i].creature_damage>0 and not player.has_invuln then
                        player.health -= creatures[i].creature_damage
                        player.is_hit = true
                        player.hit_since = 0
                        player.has_invuln = true
                    end
                end
            end
        end
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

    -- chooses the current sprite for the player
    local function update_player_animation()
        local moving,x_flip,sprinting
        if game_status=="playing" then
            moving=(not is.moving.down
                or is.moving.left or is.moving.right)
        -- only run if in playing mode, otherwise just default
        elseif game_status=="title_screen" then
            moving=(is.moving.down or is.moving.up
                or is.moving.left or is.moving.right)
        end
        sprinting=game_status=="playing" and is.moving.up
        local sprite=49
        if moving then sprite+=1 end
        if is.shooting then sprite+=2 end
        if is.drilling then sprite+=5 end
        use_alt_sprite=moving_frame>=8
        moving_frame=(moving_frame+1)%16
        if sprinting then moving_frame=(moving_frame+1)%16 end

        if moving then
            if is.shooting then
                x_flip=false
                if use_alt_sprite then sprite+=1 end
            else
                x_flip=use_alt_sprite
            end
        end
        if is_hit then current_sprite-=16 end
        spr(sprite,x,y,1,1,x_flip,false)
    end

    -- draws player based on current state
    local function draw()
        update_player_animation()
        -- handle drilling sound
        if is.drilling then
            if fuel>0 and not playing_drill.full then
                sfx(-1,1)
                sfx(30,1)
                playing_drill.full=true
            elseif fuel<=0 and not playing_drill.empty then
                sfx(-1,1)
                sfx(31,1)
                playing_drill.empty=true
            end
        else
            sfx(-1,1)
            playing_drill.full=false
            playing_drill.empty=false
        end
    end

    local function x_f() return x end
    local function y_f() return y end
    local function drilling_f() return is.drilling end
    local function shooting_f() return is.shooting end
    local function rns_f() return is.rns end
    local function hit_f() return is_hit end

    return {
        x=x_f,
        y=y_f,
        update=update,
        draw=draw,
        give_ammo=give_ammo,
        give_health=give_health,
        get_hitbox=get_hitbox,
        get_drills_hitbox=get_drills_hitbox,
        get_damaging_drills_hitbox=get_damaging_drills_hitbox,
        is_drilling=drilling_f,
        is_shooting=shooting_f,
        is_rns=rns_f,
        is_hit=hit_f,
    }
end


