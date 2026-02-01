

-- this file contains the needed files to generate the rolling background

-- initialize map
function initialize_map()
    -- catalogue all sprites and infrastructure
    map_entity = {spr, x_coord, y_coord};
    wall_entity = {spr,x_coord, y_coord};
    map_sprites_base = {128,144,160,176};
    map_sprites_special = {
        130,146,162,178,
        131,147,163,179,
        132,148,164,180,
        133,149,165,181,
    };
    wall_sprites_left = {136,138,152,154,168,170,184,186};
    wall_sprites_right = {137,139,153,155,169,171,185,187};

    terrain = {};
    walls = {};

    camera_position = {x_coord=101, y_coord = 101};

    -- initialize terrain by looping over all positions and generating
    x_coord = 101;
    y_coord = 91;
    while (x_coord < 228) do
        while (y_coord < 228) do
            spr =
            terrain.add(_produce_map_entity(spr,x_coord,y_coord);
            x_coord += 8;
            y_coord += 8;
        end
    end

end

function _produce_map_entity(spr, x_coord, y_coord)
    return {spr=spr, x_coord=x_coord, y_coord=y_coord};
end


