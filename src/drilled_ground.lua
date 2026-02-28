

function new_drilled_ground()
    local list = new_entity_container()

    local function spawn(x,y)
        list.add({x=x,y=y})
    end

    local function update()
        if game_status=="playing" then
            for i=list.size(),1,-1 do
                list.get(i).y+=1
                if list.get(i).y>=230 then
                    list.deletei(i)
                end
            end
        end
    end

    local function draw()
        for i=1,list.size() do
            spr(183,list.get(i).x,list.get(i).y)
        end
    end

    return {
        spawn=spawn,
        update=update,
        draw=draw,
    }
end


