

function oppressor(x,y)
    local frame=1
    local x=x
    local y=y
    local alive=true
    local creature_damage=1
    local hitbox={x={2,15},y={1,14}}

    local function update()
        if playing then
            y+=1
            if frame%30==0 then y+=1 end
        end
        frame=frame%60+1
    end

    local function damage(damage_received,player)
        sfx(47,3)
    end

    local function draw()
        local x_flip=frame>30
        spr(5,x,y,2,2,x_flip,false)
    end

    return {
        update=update,
        damage=damage,
        creature_damage=creature_damage,
        draw=draw,
        hitbox=hitbox,
        x=function() return x end,
        y=function() return y end,
        is_alive=function() return alive end,
    }
end


