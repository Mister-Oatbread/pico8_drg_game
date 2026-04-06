

-- this file takes care of the fancy props
function new_props()
    local props=new_entity_container()
    local props_ratios={
        {1,nectar_rind},
        {1,orchey_shy},
        {.1,p0q},
    }
    local prop_spawn_params=generate_spawn_params(
        props_ratios,#props_ratios
    )

    local function spawn_prop()
        local x=sample_one(101,220)
        local y=81

        local prop=pick_spawn(prop_spawn_params)
        props.add(prop(x,y))
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


