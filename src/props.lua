

-- this file takes care of the fancy props
function new_props()
    local props=new_entity_container()

    local function spawn_prop()
        local x=sample_one(101,220)
        local y=81
        local decision=rnd(100)
        local prop

        if decision<50 then
            prop=nectar_rind(x,y)
        elseif decision<60 then
            prop=orchey_shy(x,y)
        else
            prop=p0q(x,y)
        end
        props.add(prop)
    end

    local function update()
        if playing then
            local prop
            for i=props.size(),1,-1 do
                prop=props.get(i)
                prop.update()
                if prop.y()>=240 then
                    props.deletei(i)
                end
            end
            if rnd()<.02 then
                spawn_prop()
            end
        end
    end

    function draw_props()
        for i=1,props.size() do
            props.get(i).draw()
        end
    end

    function draw_particles()
        for i=1,props.size() do
            props.get(i).draw_particles()
        end
    end

    return {
        update=update,
        draw_props=draw_props,
        draw_particles=draw_particles,
    }
end


