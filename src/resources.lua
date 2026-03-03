


function new_resources()
    local list=new_entity_container()

    local function create(x,y)
        local sprite,sprites,hitbox,res_type,start_sprite
        local decision=rnd(1)
        if decision<resource_spawn_probs[1] then
            -- red sugar
            start_sprite=136
            hitbox={x={3,6},y={3,6}}
            res_type="red_sugar"
        elseif decision<resource_spawn_probs[2] then
            -- nitra
            start_sprite=152
            hitbox={x={1,8},y={1,8}}
            res_type="nitra"
        else
            -- gold
            start_sprite=168
            hitbox={x={1,8},y={1,8}}
            res_type="gold"
        end
        sprite=start_sprite+flr(rnd(4))
        return {
            sprite=sprite,
            x=x,
            y=y,
            x_flip=rnd(2)<1,
            y_flip=rnd(2)<1,
            hitbox=hitbox,
            res_type=res_type,
        }
    end

    local function update()
        for i=list.size(),1,-1 do
            list.get(i).y+=1
            if list.get(i).y>=230 then
                list.deletei(i)
            end
        end
        if (rnd(1)<resource_spawn_rate) then
            list.add(create(flr(rnd(120))+101,81))
        end
    end

    -- check if anything is currently colliding with the drills
    -- if so, delete
    local function mine(hitbox_drills)
        local resource
        for i=resources.size(),1,-1 do
            resource=list.get(i)
            if are_colliding(get_hitbox(resource),hitbox_drills) then
                local res_type=resource.res_type
                if res_type=="red_sugar" then
                    player.give_health(1)
                elseif res_type=="nitra" then
                    player.give_ammo(.5)
                elseif res_type=="gold" then
                    points+=100
                end
                list.deletei(i)
                sfx(-1,3)
                sfx(38,3)
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

    local function list_f() return list end

    return {
        update=update,
        draw=draw,
        get_hitbox=get_hitbox,
        get_resources=list_f,
    }
end


