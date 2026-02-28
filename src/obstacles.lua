

-- this file takes care of spawning obstacles
function new_obstacles()
    local list={}
    local sprites_small={67,68,83,84,99,100,115,116}
    local sprites_big={69,71,101,103}

    local function spawn(x,y)
        local sprite,sprites,size
        if rnd(1)<obstacle_spawn_probs[1] then
            sprites=sprites_small
            size=1
        else
            sprites=sprites_big
            size=2
        end
        sprite=sprites[flr(rnd(#sprites))+1]
        return {
            sprite=sprite,
            x=x,
            y=y,
            size=size,
            x_flip=rnd(2)<1,
            y_flip=rnd(2)<1,
        }
    end

    local function update()
        if game_status=="playing" then
            for i=#list,1,-1 do
                list[i].y+=1;
                if list[i].y>=230 then
                    deli(list,i)
                end
            end
            if rnd(1)<obstacle_spawn_rate then
                add(list,spawn(flr(rnd(120))+101,81))
            end
        end
    end

    local function draw()
        local sprite,x,y,size,x_flip,y_flip
        for i=1,#list do
            sprite=list[i].sprite
            x=list[i].x
            y=list[i].y
            size=list[i].size
            x_flip=list[i].x_flip
            y_flip=list[i].y_flip
            spr(sprite,x,y,size,size,x_flip,y_flip)
        end
    end

    return {
        update=update,
        draw=draw,
    }
end


