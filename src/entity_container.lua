

-- framework that allows to expose basic operations on entity register
-- of any closure
function new_entity_container()
    local entities={}

    local function add_entity(entity)
        add(entities,entity)
    end

    local function get_entities(i)
        return entities[i]
    end

    local function delete_entity(entity)
        del(entities,entity)
    end

    local function deletei_entity(i)
        deli(entities,i)
    end

    local function size_entities()
        return #entities
    end

    local function replace_entity(i,new_entity)
        entities[i]=new_entity
    end

    return {
        add=add_entity,
        get=get_entities,
        delete=delete_entity,
        deletei=deletei_entity,
        size=size_entities,
        replace=replace_entity,
    }
end


