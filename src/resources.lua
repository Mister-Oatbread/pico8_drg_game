

-- this file contains all resources (gold/nitra/red sugar)

-- produce one of the three entities randomly
function _produce_resource_entity(x_coord,y_coord)
    local sprite_list;
    local decision = rnd(1);
    local sprite,  x_flip, y_flip, hitbox;
    if (decision<resource_spawn_probs[1]) then
        sprite_list=red_sugar_sprites;
        hitbox=red_sugar_hitbox;
    elseif(decision<resource_spawn_probs[2]) then
        sprite_list=nitra_sprites;
        hitbox=nitra_hitbox;
    else
        sprite_list=gold_sprites;
        hitbox=gold_hitbox;
    end
    x_flip = rnd(2) < 1;
    y_flip = rnd(2) < 1;

    sprite = sprite_list[flr(rnd(#sprite_list))+1];

    return {
        sprite=sprite,
        x_coord=x_coord,
        y_coord=y_coord,
        x_flip=x_flip,
        y_flip=y_flip,
        hitbox=hitbox,
    };
end

function initialize_resources()
    resources = {};
    red_sugar_sprites = {64,80,96,112};
    nitra_sprites = {65,81,97,113};
    gold_sprites = {66,82,98,114};
    red_sugar_hitbox = {x={3,6},y={3,6}};
    nitra_hitbox = {x={1,8},y={1,8}};
    gold_hitbox = {x={1,8},y={1,8}};
    mining_sound = 38;
end

-- spawn random objects
function update_resources()
    if game_status == "playing" then
        local i=1;
        while (#resources>=i) do
            resources[i].y_coord+=1;
            if resources[i].y_coord>=235 then
                deli(resources,i);
            else
                i+=1;
            end
        end
        if (rnd(1) < resource_spawn_rate) then
            local x_coord = flr(rnd(120))+101;
            add(resources, _produce_resource_entity(x_coord,81));
        end
    end
end

-- checks if the player is below the resource and currently drilling
-- successfully, which means that the resource will be mined in 1 hit
function update_mined_resources()
    local i=1;
    local resource_box;
    if (#resources > 0) and player.is_drilling then
        drills_box = get_drills_hitbox(player)
        while #resources >= i do
            resource_box = get_resource_hitbox(resources[i]);
            if are_colliding(drills_box, resource_box) then
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
                sfx(-1,3);
                sfx(mining_sound,3);
                if #resources == 0 then break end;
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


