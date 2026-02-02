

-- this file contains all resources (gold/nitra/red sugar)

-- produce one of the three entities randomly
function _produce_resource_entity(x_coord,y_coord)
    local sprite_list;
    local decision = rnd(3);
    if (decision<1) then
        sprite_list=red_sugar_sprites;
    elseif(decision<2) then
        sprite_list=nitra_sprites;
    else
        sprite_list=gold_sprites;
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

function initialize_resources()
    resources = {};
    red_sugar_sprites = {64,80,96,112};
    nitra_sprites = {65,81,97,113};
    gold_sprites = {66,82,98,114};
    resource_spawn_chance = .01;
end

-- spawn random objects
function update_resources()
    local i=1;
    while (#resources>=i) do
        resources[i].y_coord+=1;
        if resources[i].y_coord>=235 then
            deli(resources,i);
        else
            i+=1;
        end
    end
    if (rnd(1) < resource_spawn_chance) then
        local x_coord = flr(rnd(120))+101;
        add(resources, _produce_resource_entity(x_coord,81));
    end
end

-- checks if the player is below the resource and currently drilling
-- successfully, which means that the resource will be mined in 1 hit
function update_mined_resources()
    local i=1;
    if (#resources > 0) do
        while #resources >= i do
            local x_pos_good = abs(player.x_pos-resources[i].x_coord)<8;
            local y_pos_good = abs(player.y_pos-resources[i].y_coord-4)<4;
            if (x_pos_good and y_pos_good) then

                -- resource is being updated, check type
                for sprite in all(nitra_sprites) do
                    if resources[i].sprite == sprite then
                        give_ammo(.5);
                    end
                end
                for sprite in all(gold_sprites) do
                    if resources[i].sprite == sprite then
                        player.points+=100;
                    end
                end
                for sprite in all(red_sugar_sprites) do
                    if resources[i].sprite == sprite then
                        give_health(1);
                    end
                end

                deli(resources,i);
                if #resources == 0 then break end
            else
                i+=1;
            end
        end
    end
end

function draw_resources()
    local sprite, x_coord, y_coord, x_flip, y_flip;
    if #resources > 0 then
        for i=1,#resources do
            sprite = resources[i].sprite;
            x_coord = resources[i].x_coord;
            y_coord = resources[i].y_coord;
            x_flip = resources[i].x_flip;
            y_flip = resources[i].y_flip;
            spr(sprite,x_coord,y_coord,1,1,x_flip,y_flip);
        end
    end
end


