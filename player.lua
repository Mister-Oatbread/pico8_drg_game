

-- this file contains the logic for the player character

-- initialize player
function initialize_player()
    player_sprites = {
        standing = 49,
        moving = 51,
        drilling = 54,
    };
    player = {
        is_moving = false,
        is_shooting = false,
        is_drilling = false,
        playing_drill = {empty=false,full=false},
        is_moving = {up, down, left, right};

        ammo = 50,
        fuel = 50,
        max_ammo = 50,
        max_fuel = 50,

        points = 0,
        health = 3,
        max_health = 3,
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
    if player.is_drilling then drill() end;
    if player.is_shooting then shoot() end;
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
end

-- give ammo based on max capacity and cap it
function give_ammo(percentage)
    player.ammo += player.max_ammo*percentage;
    player.fuel += player.max_fuel*percentage;

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
        player.x_pos -= 1;
    end;
    if player.is_moving.right and not player.has_collision.right then
        player.x_pos += 1;
    end;
    if player.has_collision.top then
        player.y_pos += 1;
    end;
end

-- draws player based on current state
function draw_player()
    if player.is_shooting then
        sprite=51;
    elseif player.is_drilling then
        sprite=54;
    else
        sprite=49;
    end
    spr(
        sprite,
        player.x_pos,
        player.y_pos,
        1,1,
        false,
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


