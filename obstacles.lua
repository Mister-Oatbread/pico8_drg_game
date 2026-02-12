

-- this file takes care of spawning obstacles

-- takes x,y coord and creates a random obstacle
function _produce_obstacle_entity(x_coord,y_coord)
    local sprite_list;
    local health;
    local size;
    if (rnd(1) < obstacle_spawn_probs[1]) then
        sprite_list = obstacle_sprites_small;
        size = obstacle_size.small;
    else
        sprite_list = obstacle_sprites_big;
        size = obstacle_size.big;
    end

    local x_flip = rnd(2) < 1;
    local y_flip = rnd(2) < 1;

    local sprite = sprite_list[flr(rnd(#sprite_list))+1];
    return {
        sprite=sprite,
        x_coord=x_coord,
        y_coord=y_coord,
        size=size,
        x_flip=x_flip,
        y_flip=y_flip,
    };
end

-- initialize obstacles, none should be there at the beginning
-- chonkers can't be destroyed
function initialize_obstacles()
    obstacles = {};
    drilled_ground_obstacles = {};
    obstacle_sprites_small = {67,68,83,84,99,100,115,116};
    obstacle_sprites_big = {69,71,101,103};
    obstacle_sprites_chonker = {77};
    obstacle_size = {small=1,big=2,chonker=2};
    drilled_ground_sprite = 183;
end

-- updates all obstacles and constructs/destructs new ones
function update_obstacles()
    -- shift all down
    if game_status == "playing" then
        local i = 1;
        while (#obstacles>=i) do
            obstacles[i].y_coord+=1;
            if obstacles[i].y_coord>=235 then
                deli(obstacles,i);
            else
                i+=1;
            end
        end

        i = 1;
        while (#drilled_ground_obstacles>=i) do
            drilled_ground_obstacles[i].y_coord+=1;
            if drilled_ground_obstacles[i].y_coord>=235 then
                deli(drilled_ground_obstacles,i);
            else
                i+=1;
            end
        end

        if (rnd(1) < obstacle_spawn_rate) then
            local x_coord = flr(rnd(120))+101;
            add(obstacles, _produce_obstacle_entity(x_coord,81));
        end
    end
end

-- paint all obstacles
function draw_obstacles()
    local sprite, x_coord, y_coord, size, x_flip, y_flip;
    if #obstacles > 0 then
        for i=1,#obstacles do
            sprite = obstacles[i].sprite;
            x_coord = obstacles[i].x_coord;
            y_coord = obstacles[i].y_coord;
            size = obstacles[i].size;
            x_flip = obstacles[i].x_flip;
            y_flip = obstacles[i].y_flip;
            spr(sprite,x_coord,y_coord,size,size,x_flip,y_flip);
        end
    end
end

function draw_drilled_ground_obstacles()
    local x_coord, y_coord;
    if #drilled_ground_obstacles > 0 then
        for ground in all(drilled_ground_obstacles) do
            x_coord = ground.x_coord;
            y_coord = ground.y_coord;
            spr(drilled_ground_sprite, x_coord, y_coord, 1, 1, false, false);
        end
    end
end

