

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
    local x_coord = x;
    local y_coord = y;
    local damaged_since = 0;
    local was_damaged = false;
    local x_flip = false;
    local health = 30;
    local is_alive = true;
    function animate()
        y_coord += 1;
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
    function damage(damage)
        was_damaged = true;
        health -= damage;
        if (health <= 0) then
            is_alive = false;
            give_ammo(.2);
        end
    end
    function draw()
        spr(sprite,x_coord,y_coord,1,1,x_flip,false);
    end
    return {
        y_coord=y_coord,
        animate=animate,
        damage=damage,
        draw=draw,
        is_alive=is_alive,
    };
end

function cave_angel(x,y)
    local sprite = creature_sprites.cave_angel.default;
    local frame = 0;
    local x_coord = x;
    local y_coord = y;
    local damaged_since = 0;
    local was_damaged = false;
    local x_flip = false;
    local health = 30;
    local is_alive = true;
    function animate()
        y_coord += 1;

        if frame%10==0 then
            y_coord+=1;
        end

        if (frame > 30) then
            wings_open = false
        else
            wings_open = true;
        end
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
    function damage(damage)
        was_damaged = true;
        health -= damage;
        if (health <= 0) then
            is_alive = false;
        end
    end
    function draw()
        spr(sprite,x_coord,y_coord,1,1,x_flip,false);
    end
    return {
        y_coord=y_coord,
        animate=animate,
        damage=damage,
        draw=draw,
        is_alive=is_alive,
    };
end

function grunt()
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
    if rnd() < .7 then
        creature = loot_bug(x_coord, y_coord);
    else
        creature = cave_angel(x_coord, y_coord);
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
end

function update_creatures()
    if #creatures>0 then
        for creature in all(creatures) do
            creature.animate();
        end
    end
    if rnd()<.1 then
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


