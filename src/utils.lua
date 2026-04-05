

-- takes two objects a,b of the form {x1,x2,y1,y2}, and states
-- whether their hitboxes overlap at any point
-- note that k2>k1
function are_colliding(a, b)
    local x_good = a.x[1]>b.x[2] or a.x[2]<b.x[1]
    local y_good = a.y[1]>b.y[2] or a.y[2]<b.y[1]
    return not(x_good or y_good)
end

function coinflip() return rnd(2)<1 end

function sample_one(first,last) return first+flr(rnd(last-first+1)) end

function choose_one(list) return list[flr(rnd(#list))+1] end

-- returns one index based on ratios of ratios table
-- entry 1 must contain the ratios, and entry 2 contains the thing that
-- is returned
function pick_spawn(spawn_params)
    -- take value at slot 0, which should contain the cum sum of the entire
    -- ratios table
    local decision=rnd(spawn_params.cum_sum)

    -- compare until spawn params is small enough,
    -- then return corresponding entry
    for i=1,spawn_params.variety do
        if decision<spawn_params.ratios[i][1] then
            return spawn_params.ratios[i][2]
        else
            decision-=spawn_params.ratios[i][1]
        end
    end
end

-- takes ratios and variety (no of different spawns), and bundles everything
-- into a table holding this information
function generate_spawn_params(ratios,variety)
    local sum=0
    for i=1,variety do
        sum+=ratios[i][1]
    end
    local new_ratios={}
    new_ratios.ratios=ratios
    new_ratios.cum_sum=sum
    new_ratios.variety=variety
    print(new_ratios)
    return new_ratios
end

-- -- calculate cumulative probability based on ratios up to variety
-- function get_cum_probs(ratios,variety)
--     local sum=0
--     local probs={}
--
--     for ratio in all(ratios) do
--         add(probs, ratio)
--         sum+=ratio
--     end
--
--     -- calculate separate probabilities
--     for i=1,#probs do
--         probs[i] = probs[i]/sum
--     end
--
--     -- calculate cumulative probability by summing over all probabilities that
--     -- came before
--     for i=2,#probs do
--         probs[i] += probs[i-1]
--     end
--
--     return probs
-- end

-- CURRENTLY OUT OF ORDER
-- -- takes a entity container and removes all entities that have a x
-- -- coordinate that is larger than 240
-- function remove_bottom_entities(container,y_getter)
--     local entity
--     for i=container.size(),1,-1 do
--         entity=container.get(i)
--         if entity.y>=240 then
--             container.delete(entity)
--         end
--     end
-- end
--
-- -- TODO: check if you can generalize this to house most of the update loops
-- function iterate(list,update_command)
--     return false
-- end


