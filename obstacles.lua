

-- this file takes care of spawning obstacles

-- takes x,y coord and creates a random obstacle
function _produce_obstacle_entity(x_coord,y_coord)
    local sprite_list;
    local health;
    local size;
    if (rnd(1) < .95) then
        sprite_list = obstacle_sprites_small;
        health = obstacle_health.small;
        size = obstacle_size.small;
    else
        sprite_list = obstacle_sprites_big;
        health = obstacle_health.big;
        size = obstacle_size.big;
    end

    local x_flip = rnd(2) < 1;
    local y_flip = rnd(2) < 1;

    local sprite = sprite_list[flr(rnd(#sprite_list))+1];
    return {
        sprite=sprite,
        x_coord=x_coord,
        y_coord=y_coord,
        health=health,
        size=size,
        x_flip=x_flip,
        y_flip=y_flip,
    };
end

-- initialize obstacles, none should be there at the beginning
-- chonkers can't be destroyed
function initialize_obstacles()
    obstacles = {};
    obstacle_sprites_small = {67,68,83,84,99,100,115,116};
    obstacle_sprites_big = {69,71,101,103};
    obstacle_sprites_chonker = {77};
    obstacle_health = {small=30,big=90,chonker=4000};
    obstacle_size = {small=1,big=2,chonker=2};
    obstacle_spawn_chance = .2;
end

-- updates all obstacles and constructs/destructs new ones
function update_obstacles()
    -- shift all down
    local i = 1;
    while (#obstacles>=i) do
        obstacles[i].y_coord+=1;
        if obstacles[i].y_coord>=235 then
            deli(obstacles,i);
        end
        i+=1;
    end
    if (rnd(1) < obstacle_spawn_chance) then
        x_coord = flr(rnd(120))+101;
        add(obstacles, _produce_obstacle_entity(x_coord,81));
    end
end

-- paint all obstacles
function draw_obstacles()
    local sprite;
    local x_coord;
    local y_coord;
    local size;
    local x_flip;
    local y_flip;
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


