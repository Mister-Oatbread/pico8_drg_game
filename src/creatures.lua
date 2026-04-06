

-- this file contains all information on enemies

-- -- this function takes care of handle being hit
-- function handle_creature_being_damaged(was_damaged, damaged_since)
--     damaged_since += 1
--     if damaged_since > damaged_sprite_duration then
--         was_damaged = false
--         damaged_since = 0
--     end
--     return was_damaged, damaged_since
-- end

function new_creatures()
    local creatures_list=new_entity_container()
    -- add bottom grunts to the creatures.
    for x=106,220,9 do
        creatures_list.add(bottom_grunt(x,222))
    end

    -- handles spawning a creature with correspondig percentages, and
    -- adds it to creatures list
    local function spawn_creature()
        local x=sample_one(101,220)
        local y=81

        local creature=pick_spawn(game_logic.creature_spawn_params())
        if creature==menace then x=coinflip() and 104 or 216 end
        creatures_list.add(creature(x,y))
    end

    local function update()
        local creature
        for i=creatures_list.size(),1,-1 do
            creature=creatures_list.get(i)
            creature.update()
            if creature.y()>=240 then
                creatures_list.delete(creature)
            elseif not creature.is_alive() then
                creatures_list.delete(creature)
            end
        end
    end

    local function draw()
        for i=1,creatures_list.size() do
            creatures_list.get(i).draw()
        end
    end

    -- takes in creature and returns hitbox ready to be
    -- processed by are_colliding()
    function get_hitbox(creature)
        local x1=creature.hitbox.x[1]+creature.x()-1;
        local x2=creature.hitbox.x[2]+creature.x()-1;
        local y1=creature.hitbox.y[1]+creature.y()-1;
        local y2=creature.hitbox.y[2]+creature.y()-1;
        return {x={x1,x2},y={y1,y2}};
    end

    return {
        spawn=spawn_creature,
        update=update,
        draw=draw,
        get_hitbox=get_hitbox,
        creatures_list=creatures_list,
    }
end


