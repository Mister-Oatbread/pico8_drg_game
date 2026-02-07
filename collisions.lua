

-- this file provides collision handling between the player and other stuff

-- this function calculates the player collision points based on the current
-- player position
function _update_player_collision_points()
    -- left flank
    local i=1;
    for y=player.y_pos,player.y_pos+6 do
        player.collision_points.left[i].x=player.x_pos;
        player.collision_points.left[i].y=y;
        i+=1;
    end
    -- right flank
    i=1;
    for y=player.y_pos,player.y_pos+6 do
        player.collision_points.right[i].x=player.x_pos+7;
        player.collision_points.right[i].y=y;
        i+=1;
    end
    -- top flank
    i=1;
    for x=player.x_pos+1,player.x_pos+6 do
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


