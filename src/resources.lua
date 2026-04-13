


function new_resources()
    local list=new_entity_container()

    local function spawn_resource(x,y,type)
        local sprite,hitbox,start_sprite
        local res_type=type or pick_spawn(game_logic.resource_spawn_params())
        if res_type=="red_sugar" then
            start_sprite=136
            hitbox={x={3,6},y={3,6}}
        elseif res_type=="nitra" then
            start_sprite=152
            hitbox={x={1,8},y={1,8}}
        else
            start_sprite=168
            hitbox={x={1,8},y={1,8}}
        end
        sprite=sprite or sample_one(start_sprite,start_sprite+3)

        list.add({
            sprite=sprite,
            x=x or sample_one(101,220),
            y=y or 81,
            x_flip=coinflip(),
            y_flip=coinflip(),
            hitbox=hitbox,
            res_type=res_type,
        })
    end

    -- allows to sapwn menu items, which are used to display stuff
    -- in the main menu
    local function spawn_menu_item(x,y,sprite,type,value)
        list.add({
            sprite=sprite,
            x=x,
            y=y,
            x_flip=false,
            y_flip=type=="class",
            hitbox=type=="class" and {x={2,7},y={2,7}} or {x={2,8},y={1,8}},
            res_type=type,
            value=value
        })
    end

    local function update()
        if playing then
            for i=list.size(),1,-1 do
                list.get(i).y+=1
                if list.get(i).y>=230 then
                    list.deletei(i)
                end
            end
        end
    end

    local function get_hitbox(resource)
        local x1=resource.x+resource.hitbox.x[1]-1;
        local x2=resource.x+resource.hitbox.x[2]-1;
        local y1=resource.y+resource.hitbox.y[1]-1;
        local y2=resource.y+resource.hitbox.y[2]-1;
        return {x={x1,x2},y={y1,y2}};
    end

    local function draw()
        local sprite,x,y,x_flip,y_flip,resource
        for i=1,list.size() do
            resource=list.get(i)
            sprite=resource.sprite
            x=resource.x
            y=resource.y
            x_flip=resource.x_flip
            y_flip=resource.y_flip
            spr(sprite,x,y,1,1,x_flip,y_flip)
        end
    end

    return {
        update=update,
        draw=draw,
        get_hitbox=get_hitbox,
        get_resources=list,
        spawn_resource=spawn_resource,
        spawn_menu_item=spawn_menu_item,
    }
end


