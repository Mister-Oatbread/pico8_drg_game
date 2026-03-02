

-- framework that allows to expose basic operations on entity register
-- of any closure
function new_entity_container()
    local list={}

    local function add_entity(entity)
        add(list,entity)
    end

    local function get_list(i)
        return list[i]
    end

    local function delete_entity(entity)
        del(list,entity)
    end

    local function deletei_entity(i)
        deli(list,i)
    end

    local function size_list()
        return #list
    end

    local function replace_entity(i,new_entity)
        list[i]=new_entity
    end

    return {
        add=add_entity,
        get=get_list,
        delete=delete_entity,
        deletei=deletei_entity,
        size=size_list,
        replace=replace_entity,
    }
end


