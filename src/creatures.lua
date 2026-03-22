

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
    local creatures=new_entity_container()
    -- add bottom grunts to the creatures.
    for x=106,220,9 do
        creatures.add(bottom_grunt(x,222))
    end

    -- handles spawning a creature with correspondig percentages, and
    -- adds it to creatures list
    local function spawn_creature()
        local creature_ratios=game_logic.creature_ratios()
        local creature
        local x=sample_one(102,118)
        local y=81

        local creature=choose_from_cum_prob(game_logic.creature_ratios())
        creatures.add(creature(x,y))
    end

    local function update()
        local creature
        for i=creatures.size(),1,-1 do
            creature=creatures.get(i)
            creature.update()
            if creature.y()>=240 then
                creatures.delete(creature)
            elseif not creature.is_alive() then
                creatures.delete(creature)
            end
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
        spawn=spawn_creature,
        update=update,
        draw=draw,
        get_hitbox=get_hitbox,
        creatures=creatures,
    }
end


