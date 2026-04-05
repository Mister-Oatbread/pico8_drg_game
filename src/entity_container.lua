

-- framework that allows to expose basic operations on entity register
-- of any closure
function new_entity_container()
    local entities={}
    return {
        add=function(entity) add(entities,entity) end,
        get=function(i) return entities[i] end,
        delete=function(entity) del(entities,entity) end,
        deletei=function(i) deli(entities,i) end,
        size=function() return #entities end,
        replace=function(i,new_entity) entities[i]=new_entity end,
    }
end


