

-- this file takes care of the fancy props
-- TODO: this should calculated after setup
-- TODO: generally decide where the ratios will land

local function spawn_prop()
    local x=sample_one(101,220)
    local y=81

    local props_ratios={
        {1,orchey_shy},
        {.1,p0q},
        {1,void_basket},
        {1,callow_seeder},
        {1,nectar_rind},
    }
    local prop=pick_spawn(generate_spawn_params(props_ratios,#props_ratios))
    props.add(prop(x,y))
end

function update_props()
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


