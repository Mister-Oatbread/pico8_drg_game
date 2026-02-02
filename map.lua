

-- this file contains the needed files to generate the rolling background

-- takes x,y coord and creates a random base sprite with a 70% chance,
-- or special sprite else
function _produce_map_entity(x_coord, y_coord)
    local sprite_list;
    if (rnd(1) < .75) then
        sprite_list = map_sprites_base;
    else
        sprite_list = map_sprites_special;
    end
    local x_flip = rnd(2) < 1;
    local y_flip = rnd(2) < 1;

    local sprite = sprite_list[flr(rnd(#sprite_list))+1];
    return {
        sprite=sprite,
        x_coord=x_coord,
        y_coord=y_coord,
        x_flip=x_flip,
        y_flip=y_flip,
    };
end

-- takes x,y coord and creates a random wall sprite with random x flip and
-- according orientation for wall
function _produce_wall_entity(x_coord, y_coord)
    x_flip = x_coord > 140;
    y_flip = rnd(2) < 1;

    local sprite = wall_sprites[flr(rnd(#wall_sprites))+1];
    return {
        sprite=sprite,
        x_coord=x_coord,
        y_coord=y_coord,
        x_flip=x_flip,
        y_flip=y_flip,
    };
end

-- initialize map
function initialize_map()
    -- catalogue all sprites and infrastructure
    map_entity = {sprite, x_coord, y_coord};
    wall_entity = {sprite,x_coord, y_coord};
    map_sprites_base = {128,144,160,176};
    map_sprites_special = {
        130,146,162,178,
        131,147,163,179,
        132,148,164,180,
        133,149,165,181,
    };
    wall_sprites = {
        136,138,152,154,168,170,184,186,
        137,139,153,155,169,171,185,187,
    };
    terrain = {};
    walls = {};

    camera_position = {x_coord=101, y_coord = 101};

    -- initialize terrain by looping over all positions and generating
    -- random sprite
    local x_coord = 101;
    local y_coord = 91;
    while (x_coord < 228) do
        while (y_coord < 228) do
            add(terrain,_produce_map_entity(x_coord,y_coord));
            y_coord += 8;
        end
        x_coord += 8;
        y_coord = 91;
    end

    -- initialize walls with random sprite
    x_coord = 101;
    y_coord = 91;
    while (x_coord < 228) do
        while (y_coord < 228) do
            add(walls, _produce_wall_entity(x_coord, y_coord));
            y_coord += 8
        end
        x_coord += 120;
        y_coord = 91;
    end
end

-- slides the floor one frame to the bottom, and realigns the floor if needed
function update_map()
    for i=1,#terrain do
        terrain[i].y_coord += 1;
        if (terrain[i].y_coord >= 235) then
            terrain[i] = _produce_map_entity(terrain[i].x_coord,91);
        end
    end
    for i=1,#walls do
        walls[i].y_coord += 1;
        if (walls[i].y_coord >= 235) then
            walls[i] = _produce_wall_entity(walls[i].x_coord,91);
        end
    end
end

-- paint all terrain tiles at their current location
function draw_map()
    local sprite;
    local x_coord;
    local y_coord;
    local x_flip;
    local y_flip;
    for i=1,#terrain do
        sprite = terrain[i].sprite;
        x_coord = terrain[i].x_coord;
        y_coord = terrain[i].y_coord;
        x_flip = terrain[i].x_flip;
        y_flip = terrain[i].y_flip;
        spr(sprite,x_coord,y_coord,1,1,x_flip,y_flip);
    end
    for i=1,#walls do
        sprite = walls[i].sprite;
        x_coord = walls[i].x_coord;
        y_coord = walls[i].y_coord;
        x_flip = walls[i].x_flip;
        y_flip = walls[i].y_flip;
        spr(sprite,x_coord,y_coord,1,1,x_flip,y_flip);
    end
end


