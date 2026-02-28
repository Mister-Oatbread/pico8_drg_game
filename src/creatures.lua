

-- this file contains all information on enemies

-- this function takes care of handle being hit
function handle_creature_being_damaged(was_damaged, damaged_since)
    damaged_since += 1
    if damaged_since > damaged_sprite_duration then
        was_damaged = false
        damaged_since = 0
    end
    return was_damaged, damaged_since
end

function new_creatures()
    creatures = new_entity_container()
    -- add bottom grunts to the creatures.
    for x=106,220,9 do
        creatures.add(bottom_grunt(x,222))
    end

    -- handles spawning a creature with correspondig percentages, and
    -- adds it to creatures list
    local function spawn_creature()
        local creature
        local x=flr(rnd(120))+101
        local y=81
        local decision=rnd()
        if decision<creature_spawn_probs[1] then
            if rnd(1000)<1 then
                creature=egg(x,y)
            else
                creature=loot_bug(x,y)
            end
        elseif decision<creature_spawn_probs[2] then
            creature=cave_angel(x,y)
        elseif decision<creature_spawn_probs[3] then
            creature=grunt(x,y)
        elseif decision<creature_spawn_probs[4] then
            creature=slasher(x,y)
        elseif decision<creature_spawn_probs[5] then
            creature=mactera(x,y)
        else
            creature=praetorian(x,y)
        end
        creatures.add(creature)
    end

    local function update()
        local creature
        for i=creatures.size(),1,-1 do
            creature=creatures.get(i).update()
            if creature.y()>=240 then
                creatures.delete(creature)
            elseif not creature.is_alive() then
                creatures.delete(creature)
            end
        end
        if rnd()<creature_spawn_rate then
            spawn_creature()
        end
    end

    local function draw()
        for i=1,#creatures do
            creatures[i].draw()
        end
    end

    -- takes in creature and returns hitbox ready to be
    -- processed by are_colliding()
    function get_hitbox()
        local x1=hitbox.x[1]+x()-1;
        local x2=hitbox.x[2]+x()-1;
        local y1=hitbox.y[1]+y()-1;
        local y2=hitbox.y[2]+y()-1;
        return {x={x1,x2},y={y1,y2}};
    end

    return {
        update=update,
        draw=draw,
        get_hitbox=get_hitbox,
        creatures=creatures,
    }
end


