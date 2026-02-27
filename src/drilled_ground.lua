

function drilled_ground()
    local list={}

    local function spawn(x,y)
        add(list,{x=x,y=y})
    end

    local function update()
        for i=#list,1,-1 do
            list[i].y+=1
            if list[i].y>=230 then
                deli(list,i)
            end
        end
    end

    local function draw()
        for i=1,#list do
            spr(183,list[i].x,list[i].y)
        end
    end

    return {
        spawn=spawn,
        update=update,
        draw=draw,
    }
end


