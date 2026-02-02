

-- this file contains the logic for the player character

--
function initialize_player()
    player_sprites = {
        standing = 49,
        moving = {
            up = 51,
            right = 51,
        },
    };
    player = {
        is_moving = false,
        is_shooting = false,
        is_drilling = false,
        is_moving = {
            up = false,
            down = false,
            left = false,
            right = false,
        },
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
function _get_input()
    player.is_moving.up = btn(2);
    player.is_moving.down = btn(3);
    player.is_moving.left = btn(0);
    player.is_moving.right = btn(1);
    player.is_shooting = btn(4);
    player.is_drilling = btn(5);
end

-- checks whether the terrain colors are intercepting
function _find_terrain_collision()
    local point;
    local color;
    player.has_collision.left = false;
    player.has_collision.right = false;
    player.has_collision.top = false;
    for i=1,#player.collision_points.left do
        point = player.collision_points.left[i];
        color = pget(point.x,point.y);
        if (color==5 or color==13) then
            player.has_collision.left=true;
            break;
        end
    end
    for i=1,#player.collision_points.right do
        point = player.collision_points.right[i];
        color = pget(point.x,point.y);
        if (color==5 or color==13) then
            player.has_collision.right=true;
            break;
        end
    end
    for i=1,#player.collision_points.top do
        point = player.collision_points.top[i];
        color = pget(point.x,point.y);
        if (color==5 or color==13) then
            player.has_collision.top=true;
            break;
        end
    end
end

-- handles moving the player around
function move_player()
    _get_input();
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

-- this function calculates the player collision points based on the current
-- player position
function _update_player_collision_points()
    -- left flank
    local i;
    i=1;
    for y=player.y_pos,player.y_pos+7 do
        player.collision_points.left[i].x=player.x_pos-1;
        player.collision_points.left[i].y=y;
        i+=1;
    end
    -- right flank
    i=1;
    for y=player.y_pos,player.y_pos+7 do
        player.collision_points.right[i].x=player.x_pos+8;
        player.collision_points.right[i].y=y;
        i+=1;
    end
    -- top flank
    i=1;
    for x=player.x_pos,player.x_pos+7 do
        player.collision_points.top[i].x=x;
        player.collision_points.top[i].y=player.y_pos-1;
        i+=1;
    end
end

-- this function updates if the player would be leaving the map
function _check_map_bounds()
    player.at.top_border = player.y_pos <= 102;
    player.at.bottom_border = player.y_pos >= 220;
end

-- draws player based on current state
function draw_player()
    if player.is_shooting then sprite=51 else sprite=49 end;
    spr(
        sprite,
        player.x_pos,
        player.y_pos,
        1,1,
        false,
        false
    );
end


