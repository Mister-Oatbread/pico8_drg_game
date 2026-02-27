

-- this file contains the logic for the player character

-- initialize player
function player()
    local x=148
    local y=200
    local sprites={
        idle={standing=49,moving=50},
        drilling={standing=54,moving=55},
        shooting={standing=51,moving=52,moving_alt=53},
        rns={standing=111,moving=109,moving_alt=110},
    }
    local is={
        moving={up,down,left,right},
        shooting=false,
        drilling=false,
        rns=false}
    local playing_drill={empty=false,full=false}
    local moving_frame=0
    local x_flip=false
    local current_sprite=sprites.idle.standing
    local ammo=25
    local fuel=150
    local max_ammo=25
    local max_fuel=150
    local shots_fired=false
    local shot_delay_counter=0
    local shot_delay=3
    local points=0
    local health=3
    local max_health=3
    local is_hit=false
    local hit_since=0
    local has_invuln=false
    local invuln_duration=30
    local collision_points={left={},right={},top={}}
    local has_collision={
        left=false,
        right=false,
        top=false,
    }
    local at={
        top_border=false,
        bottom_border=false,
    }
    for i=1,8 do
        add(collision_points.left,{x=0,y=0})
        add(collision_points.right,{x=0,y=0})
        add(collision_points.top,{x=0,y=0})
    end

    -- checks inputs and writes them to the state of the player
    local function fetch_inputs()
        is.moving.up=btn(1)
        is.moving.down=btn(3)
        is.moving.left=btn(0)
        is.moving.right=btn(1)
        is.shooting=btn(5) and not btn(4)
        is.drilling=btn(4) and not btn(5)
        is.rns=btn(3) and btn(4) and btn(5)
    end

    local function drill()
        local sound
        if (player.fuel>0) then
            drilled_ground.spawn(player.x_pos,player.y_pos-1)
            player.fuel-=1
            resources.mine()

            local drill_box = get_damaging_drills_hitbox(player)
            local creature_box,creature

            -- drill creatures
            for i=#creatures,1,-1 do
                creature = creatures[i]
                creature_box = get_creature_hitbox(creature)
                if are_colliding(creature_box,drill_box) then
                    creature.damage(4)
                end
            end
        end
    end

    local function shoot()
        if player.ammo > 0 then
            fire_bullet()
            player.ammo -= 1
            sfx(-1,2)
            sfx(34,2)
        else
            sfx(-1,2)
            sfx(35,2)
        end
        player.shots_fired = true
        player.shot_delay_counter = 0
    end

    -- give ammo based on max capacity and cap it
    function give_ammo(percentage)
        player.ammo += ceil(player.max_ammo*percentage)
        player.fuel += ceil(player.max_fuel*percentage)

        if player.ammo > player.max_ammo then player.ammo = player.max_ammo end
        if player.fuel > player.max_fuel then player.fuel = player.max_fuel end
    end

    -- give player amount of health and cap it
    function give_health(amount)
        player.health += amount
        if player.health>player.max_health then player.health=player.max_health end
    end

    -- handles moving the player around
    local function update()
        fetch_inputs()
        _update_player_collision_points()
        _find_terrain_collision()
        _check_map_bounds()
        if player.is_moving.up and not player.has_collision.top then
            if not(player.at.top_border) then
                player.y_pos -= 1
            end
        end
        if player.is_moving.down then
            player.y_pos += 1
        end
        if player.is_moving.left and not player.has_collision.left then
            if player.x_pos >= 102 then
                player.x_pos -= 1
            end
        end
        if player.is_moving.right and not player.has_collision.right then
            if player.x_pos <= 220 then
                player.x_pos += 1
            end
        end
        if player.has_collision.top then
            player.y_pos += 1
        end

        if player.y_pos <= 101 then player.y_pos = 101 end
        if player.y_pos >= 221 then player.y_pos = 221 end
        check_if_hit_by_creature()
        handle_being_hit()
        if player.is_drilling then drill() end

        -- shot was recently fired, don't fire again
        if player.shots_fired and player.shot_delay_counter<player.shot_delay then
            player.shot_delay_counter+=1
        else
            -- didn't shoot recently, check if player is firing
            if player.is_shooting then shoot() end
        end
    end

    -- checks if any hostile creature is currently touching the player
    function check_if_hit_by_creature()
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

    function handle_being_hit()
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
    function update_player_animation()
        player.moving_frame = (player.moving_frame+1)%10
        local moving
        if game_status == "playing" then
            moving = (not player.is_moving.down
                or player.is_moving.left or player.is_moving.right)
        -- only run if in playing mode, otherwise just default
        elseif game_status == "title_screen" then
            moving = (player.is_moving.down or player.is_moving.up
                or player.is_moving.left or player.is_moving.right)
        end

        local use_alt_sprite = player.moving_frame>=5

        if player.is_shooting then
            if not moving then
                player.current_sprite = player_sprites.shooting.standing
            else
                if use_alt_sprite then
                    player.current_sprite = player_sprites.shooting.moving_alt
                else
                    player.current_sprite = player_sprites.shooting.moving
                end
            end
            player.x_flip = false

        elseif player.is_drilling then
            if not moving then
                player.current_sprite = player_sprites.drilling.standing
                player.x_flip = false
            else
                player.current_sprite = player_sprites.drilling.moving
                player.x_flip = use_alt_sprite
            end

        else
            if not moving then
                player.current_sprite = player_sprites.idle.standing
                player.x_flip = false
            else
                player.current_sprite = player_sprites.idle.moving
                player.x_flip = use_alt_sprite
            end
        end

        if player.is_hit then
            player.current_sprite -=16
        end
    end

    -- draws player based on current state
    function draw_player()
        update_player_animation()
        spr(
            player.current_sprite,
            player.x_pos,
            player.y_pos,
            1,1,
            player.x_flip,
            false
        )

        -- handle drilling sound
        if player.is_drilling then
            if player.fuel>0 and not player.playing_drill.full then
                sfx(-1,1)
                sfx(30,1)
                player.playing_drill.full = true
            elseif player.fuel<=0 and not player.playing_drill.empty then
                sfx(-1,1)
                sfx(31,1)
                player.playing_drill.empty = true
            end
        else
            sfx(-1,1)
            player.playing_drill.full= false
            player.playing_drill.empty = false
        end
    end
    return {
        update=update,
        draw=draw,
    }
end


