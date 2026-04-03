

function oppressor(x,y)
    local frame=1
    local x=x
    local y=y
    local alive=true
    local creature_damage=1
    local hitbox={x={2,15},y={1,14}}

    local function update()
        if game_status=="playing" then
            y+=1
            if frame%30==1 then y+=1 end
        end
        frame=frame%60+1
    end

    local function damage(damage_received,player)
    end

    local function draw()
        local x_flip=frame>30
        spr(5,x,y,2,2,x_flip,false)
    end

    local function x_f() return x end
    local function y_f() return y end
    local function is_alive() return alive end

    return {
        x=x_f,
        y=y_f,
        update=update,
        damage=damage,
        creature_damage=creature_damage,
        draw=draw,
        hitbox=hitbox,
        is_alive=is_alive,
    }
end


