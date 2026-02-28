

function new_resources()
    local list={}
    local red_sugar_sprites={64,80,96,112}
    local nitra_sprites={65,81,97,113}
    local gold_sprites={66,82,98,114}
    local red_sugar_hitbox={x={3,6},y={3,6}}
    local nitra_hitbox={x={1,8},y={1,8}}
    local gold_hitbox={x={1,8},y={1,8}}
    local mining_sound=38

    local function create(x,y)
        local sprite,sprites,hitbox,res_type
        local decision=rnd(1)
        if decision<resource_spawn_probs[1] then
            sprites=red_sugar_sprites
            hitbox=red_sugar_hitbox
            res_type="red_sugar"
        elseif decision<resource_spawn_probs[2] then
            sprites=nitra_sprites
            hitbox=nitra_hitbox
            res_type="nitra"
        else
            sprites=gold_sprites
            hitbox=gold_hitbox
            res_type="gold"
        end
        sprite=sprites[flr(rnd(#sprite_list))+1]
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
        for i=#list,1,-1 do
            list[i].y+=1
            if list[i].y_coord>=230 then
                deli(list,i)
            end
        end
        if (rnd(1)<resource_spawn_rate) then
            add(list,create(flr(rnd(120))+101,81))
        end
    end

    -- check if anything is currently colliding with the drills
    -- if so, delete
    local function mine(hitbox_drills)
        local resource
        for i=#resources,1,-1 do
            resource = resources[i]
            if are_colliding(get_hitbox(resource),hitbox_drills) then
                local res_type=resource.res_type
                if res_type=="red_sugar" then
                    give_health(1)
                elseif res_type=="nitra" then
                    give_ammo(.5)
                elseif res_type=="gold" then
                    points+=100
                end
                deli(resources,i)
                sfx(-1,3)
                sfx(mining_sound,3)
            end
        end
    end

    function get_hitbox(resource)
        local x1=resource.x+resource.hitbox.x[1]-1;
        local x2=resource.x+resource.hitbox.x[2]-1;
        local y1=resource.y+resource.hitbox.y[1]-1;
        local y2=resource.y+resource.hitbox.y[2]-1;
        return {x={x1,x2},y={y1,y2}};
    end

    local function draw()
        local sprite,x,y,x_flip,y_flip
        for i=1,#list do
            sprite=list[i].sprite
            x=list[i].x
            y=list[i].y
            x_flip=list[i].x_flip
            y_flip=list[i].y_flip
            spr(sprite,x,y,1,1,x_flip,y_flip)
        end
    end

    return {
        update=update,
        mine=mine,
        draw=draw,
    }
end


