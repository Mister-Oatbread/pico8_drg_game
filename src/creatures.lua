

-- this file contains all information on enemies

-- add bottom grunts to the creatures.

-- handles spawning a creature with correspondig percentages, and
-- adds it to creatures list
function spawn_creature(x,y,type)
    local x=x or sample_one(101,220)
    local y=y or 81

    local creature=type or pick_spawn(creature_spawn_params)
    if creature==menace then x=coinflip() and 104 or 216 end

    creatures.add(creature(x,y))
end

function update_creatures()
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

function draw_creatures()
    for i=1,creatures.size() do
        creatures.get(i).draw()
    end
end

-- takes in creature and returns hitbox ready to be
-- processed by are_colliding()
function get_creature_hitbox(creature)
    local x1=creature.hitbox.x[1]+creature.x()-1;
    local x2=creature.hitbox.x[2]+creature.x()-1;
    local y1=creature.hitbox.y[1]+creature.y()-1;
    local y2=creature.hitbox.y[2]+creature.y()-1;
    return {x={x1,x2},y={y1,y2}};
end


