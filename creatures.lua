

-- this file contains all information on enemies

-- this function takes care of handle being hit
function handle_creature_being_damaged(was_damaged, damaged_since)
    damaged_since += 1;
    if damaged_since > damaged_sprite_duration then
        was_damaged = false;
        damaged_since = 0;
    end
    return was_damaged, damaged_since;
end
function loot_bug(x,y)
    local sprite = creature_sprites.loot_bug.default;
    local frame = 0;
    local x = x;
    local y = y;
    local damaged_since = 0;
    local was_damaged = false;
    local x_flip = false;
    local health = 30;
    local alive = true;
    local creature_damage = 0;
    local hitbox={x={2,7},y={1,7}};
    function animate()
        y += 1;
        if frame%27==26 then y += 1 end;
        if (frame > 15) then
            x_flip = false;
        else
            x_flip = true;
        end
        if was_damaged then
            sprite = creature_sprites.loot_bug.damaged;
        else
            sprite = creature_sprites.loot_bug.default;
        end
        was_damaged, damaged_since = handle_creature_being_damaged(
            was_damaged, damaged_since);
        frame = (frame+1)%30;
    end
    function damage(damage_received)
        was_damaged = true;
        health -= damage_received;
        if (health <= 0) then
            alive = false;
            give_ammo(.2);
            no_lootbugs_killed = false;
        end
    end
    function draw()
        spr(sprite,x,y,1,1,x_flip,false);
    end
    function x_coord() return x end;
    function y_coord() return y end;
    function is_alive() return alive end;
    return {
        x_coord=x_coord,
        y_coord=y_coord,
        animate=animate,
        damage=damage,
        creature_damage=creature_damage,
        draw=draw,
        hitbox=hitbox,
        is_alive=is_alive,
    };
end

function cave_angel(x,y)
    local sprite = creature_sprites.cave_angel.default;
    local frame = 0;
    local x = x;
    local y = y;
    local damaged_since = 0;
    local was_damaged = false;
    local x_flip = false;
    local health = 20;
    local alive = true;
    local creature_damage = 0;
    local hitbox={x={2,7},y={1,7}};
    function animate()
        y += 1;

        if frame%10==0 then y+=1 end;
        if frame%45==0 then x+=sgn(x-player.x_pos) end;
        wings_open = frame>30;
        if was_damaged then
            if wings_open then
                sprite = creature_sprites.cave_angel.damaged;
            else
                sprite = creature_sprites.cave_angel.damaged_alt;
            end
        else
            if wings_open then
                sprite = creature_sprites.cave_angel.default;
            else
                sprite = creature_sprites.cave_angel.alt;
            end
        end
        was_damaged, damaged_since = handle_creature_being_damaged(
            was_damaged, damaged_since);
        frame = (frame+1)%60;
    end
    function damage(damage_received)
        was_damaged = true;
        health -= damage_received;
        if (health <= 0) then
            alive = false;
            no_cave_angels_killed = false;
        end
    end
    function draw()
        spr(sprite,x,y,1,1,x_flip,false);
    end
    function x_coord() return x end;
    function y_coord() return y end;
    function is_alive() return alive end;
    return {
        x_coord=x_coord,
        y_coord=y_coord,
        animate=animate,
        damage=damage,
        creature_damage=creature_damage,
        draw=draw,
        hitbox=hitbox,
        is_alive=is_alive,
    };
end

function grunt(x,y)
    local frame = 0;
    local x = x;
    local y = y;
    local damaged_since = 0;
    local display_alt = false;
    local was_damaged = false;
    local health = 40;
    local alive = true;
    local creature_damage = 1;
    local hitbox={x={1,8},y={1,8}};
    function animate()
        y += 1;
        if frame%5==0 then y+=1 end;

        display_alt = frame > 15;
        was_damaged, damaged_since = handle_creature_being_damaged(
            was_damaged, damaged_since);
        frame = (frame+1)%30;
    end
    function damage(damage_received)
        was_damaged = true;
        health -= damage_received;
        if (health <= 0) then
            alive = false;
        end
    end
    function draw()
        local sprite;
        if was_damaged then
            sprite=creature_sprites.grunt.damaged;
            x_flip = display_alt;
        else
            sprite=creature_sprites.grunt.default;
            x_flip = display_alt;
        end
        spr(sprite,x,y,1,1,x_flip,false);
    end
    function x_coord() return x end;
    function y_coord() return y end;
    function is_alive() return alive end;
    return {
        x_coord=x_coord,
        y_coord=y_coord,
        animate=animate,
        damage=damage,
        creature_damage=creature_damage,
        draw=draw,
        hitbox=hitbox,
        is_alive=is_alive,
    };
end

-- reduced grunt that provides collision at the bottom
function bottom_grunt(x,y)
    local frame = rnd(20);
    local up_down_frame = rnd(20);
    local up_down_cap = rnd(20)+40;
    local x=x;
    local y=y;
    local y0=y;
    local display_alt = false;
    local alive = true;
    local creature_damage = 1;
    local hitbox={x={1,8},y={1,8}};

    function animate()
        display_alt = frame > 15;

        -- animate grunts moving up and down
        y = y0 + sgn(up_down_frame - up_down_cap/2);

        frame = (frame+1)%30;
        up_down_frame = (up_down_frame+1)%up_down_cap;
    end
    function damage(damage_received)
    end
    function draw()
        spr(creature_sprites.grunt.default,x,y,1,1,display_alt,true);
    end
    function x_coord() return x end;
    function y_coord() return y end;
    function is_alive() return alive end;
    return{
        x_coord=x_coord,
        y_coord=y_coord,
        animate=animate,
        damage=damage,
        creature_damage=creature_damage,
        draw=draw,
        hitbox=hitbox,
        is_alive=is_alive,
    };
end

function slasher()
end

function mactera()
end

function praetorian()
end

-- handles spawning a creature with correspondig percentages, and
-- adds it to creatures list
function spawn_creature()
    local x_coord = flr(rnd(120))+101;
    local y_coord = 81;
    local decision = rnd();
    if decision < creature_spawn_probs[1] then
        creature = loot_bug(x_coord, y_coord);
    elseif decision < creature_spawn_probs[2] then
        creature = cave_angel(x_coord, y_coord);
    else
        creature = grunt(x_coord, y_coord);
    end
    add(creatures, creature);
end

-- initialize everything
function initialize_creatures()
    creatures = {};
    creature_sprites = {
        loot_bug = {default=43,damaged=44},
        cave_angel = {default=11,alt=12,damaged=13,damaged_alt=14},
        grunt = {default=1,damaged=2},
        slasher = {default=17,damaged=18},
        praetorian = {default=3,damaged=5,cloud=5,spit=9},
        mactera = {default=27,alt=28,damaged=29,damaged_alt=30},
    };

    -- add bottom grunts to the creatures.
    for x_coord=106,220,9 do
        add(creatures, bottom_grunt(x_coord, 222));
    end
end

function update_creatures()
    if #creatures>0 then
        for creature in all(creatures) do
            creature.animate();
        end

        local i=1;
        while #creatures>=i do
            if creatures[i].y_coord() >= 240 then
                deli(creatures, i);
            elseif not creatures[i].is_alive() then
                deli(creatures, i);
            else
                i+=1;
            end
        end
    end

    if rnd() < creature_spawn_rate then
        spawn_creature();
    end
end
function draw_creatures()
    if #creatures>0 then
        for creature in all(creatures) do
            creature.draw();
        end
    end
end


