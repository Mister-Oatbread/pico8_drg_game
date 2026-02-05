

-- this file contains the logic for the player character

-- initialize player
function initialize_player()
    player_sprites = {
        idle={standing=49,moving=50},
        drilling={standing=54,moving=55},
        shooting={standing=51,moving=52,moving_alt=53},
    };
    player = {
        is_moving = false,
        is_shooting = false,
        is_drilling = false,
        playing_drill = {empty=false,full=false},
        is_moving = {up, down, left, right};
        moving_frame = 0,
        x_flip = false,
        current_sprite = player_sprites.standing,

        ammo = 25,
        fuel = 150,
        max_ammo = 25,
        max_fuel = 150,

        shots_fired = false,
        shot_delay_counter = 0,
        shot_delay = 3,

        points = 0,
        health = 3,
        max_health = 3,
        is_hit = false,
        hit_since = 0,
        has_invuln = false,
        invuln_duration = 30,

        x_pos = 150,
        y_pos = 200,

        collision_points = {left={},right={},top={}},
        has_collision = {
            left=false,
            right=false,
            top=false,
        };
        at = {
            top_border = false,
            bottom_border = false,
        },
    };
    for i=1,8 do
        add(player.collision_points.left, {x=0,y=0});
        add(player.collision_points.right, {x=0,y=0});
        add(player.collision_points.top, {x=0,y=0});
    end
end

-- checks inputs and writes them to the state of the player
function update_inputs()
    player.is_moving.up = btn(2);
    player.is_moving.down = btn(3);
    player.is_moving.left = btn(0);
    player.is_moving.right = btn(1);
    player.is_shooting = btn(4);
    player.is_drilling = btn(5);
end

-- takes care of using the special abilities  the player has
function handle_player_abilities()
    if player.is_drilling and not player.is_shooting then drill() end;

    -- shot was recently fired, don't fire again
    if player.shots_fired and player.shot_delay_counter<player.shot_delay then
        player.shot_delay_counter+=1;
    else
        -- didn't shoot recently, check if player is firing
        if player.is_shooting and not player.is_drilling then shoot() end;
    end
end

-- takes care of drilling in front of the player
-- this is done by painting the tiles in front of the player with color 2,
-- which removes the collision property
-- these particles are treated as obstacles
function drill()
    local sound;
    if (player.fuel > 0) then
        -- get sprites in front of player
        local drilled_ground = {
            sprite=drilled_ground_sprite,
            x_coord=player.x_pos,
            y_coord=player.y_pos-7,
            size=1,
            x_flip=false,
            y_flip=false,
        };
        add(obstacles, drilled_ground);
        player.fuel -= 1;
        update_mined_resources();
    end
end

-- takes care of shooting in front of the player
function shoot()
    if player.ammo > 0 then
        fire_bullet();
        player.ammo -= 1;
        sfx(-1,2);
        sfx(34,2);
    else
        sfx(-1,2);
        sfx(35,2);
    end
    player.shots_fired = true;
    player.shot_delay_counter = 0;
end

-- give ammo based on max capacity and cap it
function give_ammo(percentage)
    player.ammo += ceil(player.max_ammo*percentage);
    player.fuel += ceil(player.max_fuel*percentage);

    if player.ammo > player.max_ammo then player.ammo = player.max_ammo end;
    if player.fuel > player.max_fuel then player.fuel = player.max_fuel end;
end

-- give player amount of health and cap it
function give_health(amount)
    player.health += amount;
    if player.health>player.max_health then player.health=player.max_health end;
end

-- handles moving the player around
function move_player()
    _update_player_collision_points();
    _find_terrain_collision();
    _check_map_bounds();
    if player.is_moving.up and not player.has_collision.top then
        if not(player.at.top_border) then
            player.y_pos -= 1;
        end
    end;
    if player.is_moving.down then
        player.y_pos += 1;
    end;
    if player.is_moving.left and not player.has_collision.left then
        if player.x_pos >= 102 then
            player.x_pos -= 1;
        end
    end;
    if player.is_moving.right and not player.has_collision.right then
        if player.x_pos <= 220 then
            player.x_pos += 1;
        end
    end;
    if player.has_collision.top then
        player.y_pos += 1;
    end;
    check_if_hit_by_creature();
    handle_being_hit();
end

-- checks if any hostile creature is currently touching the player
function check_if_hit_by_creature()
    local player_box = get_player_hitbox(player);
    local creature_box;
    if #creatures>0 then
        for creature in all(creatures) do
            creature_box = get_creature_hitbox(creature);
            if are_colliding(player_box, creature_box) then
                if creature.creature_damage>0 and not player.has_invuln then
                    player.health -= creature.creature_damage;
                    player.is_hit = true;
                    player.hit_since = 0;
                    player.has_invuln = true;
                end
            end
        end
    end
end

function handle_being_hit()
    if player.is_hit and player.hit_since>player.invuln_duration then
        player.hit_since = 0;
        player.is_hit = false;
        player.has_invuln = false;
    elseif player.is_hit and player.hit_since<=player.invuln_duration then
        player.hit_since+=1;
    end
end

-- chooses the current sprite for the player
function update_player_animation()
    player.moving_frame = (player.moving_frame+1)%10;
    local moving = (not player.is_moving.down
    or player.is_moving.left or player.is_moving.right);

    local use_alt_sprite = player.moving_frame>=5;

    if player.is_shooting then
        if not moving then
            player.current_sprite = player_sprites.shooting.standing;
            player.moving_frame=0;
        else
            if use_alt_sprite then
                player.current_sprite = player_sprites.shooting.moving_alt;
            else
                player.current_sprite = player_sprites.shooting.moving;
            end
        end
        player.x_flip = false;

    elseif player.is_drilling then
        if not moving then
            player.current_sprite = player_sprites.drilling.standing;
            player.x_flip = false;
            player.moving_frame=0;
        else
            player.current_sprite = player_sprites.drilling.moving;
            player.x_flip = use_alt_sprite;
        end

    else
        if not moving then
            player.current_sprite = player_sprites.idle.standing;
            player.x_flip = false;
            player.moving_frame=0;
        else
            player.current_sprite = player_sprites.idle.moving;
            player.x_flip = use_alt_sprite;
        end
    end
    if player.is_hit then
        player.current_sprite -=16;
    end
end

-- draws player based on current state
function draw_player()
    update_player_animation();
    spr(
        player.current_sprite,
        player.x_pos,
        player.y_pos,
        1,1,
        player.x_flip,
        false
    );

    -- handle drilling sound
    if player.is_drilling then
        if player.fuel>0 and not player.playing_drill.full then
            sfx(-1,1);
            sfx(30,1);
            player.playing_drill.full = true;
        elseif player.fuel<=0 and not player.playing_drill.empty then
            sfx(-1,1);
            sfx(31,1);
            player.playing_drill.empty = true;
        end
    else
        sfx(-1,1);
        player.playing_drill.full= false;
        player.playing_drill.empty = false;
    end
end


