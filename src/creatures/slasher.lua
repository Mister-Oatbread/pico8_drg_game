

function slasher(x,y)
    local frame=1
    local x=x
    local y=y
    local damaged_since=60
    local health=50
    local alive=true
    local creature_damage=2
    local hitbox={x={1,8},y={1,8}}

    local function update()
        if playing then
            y+=1
            if frame%4==0 then y+=1 end
        end
        damaged_since=min(damaged_since+1,1000)
        frame=frame%8+1
    end

    local function damage(damage_received,player)
        sfx(33,3)
        damaged_since=0
        health-=damage_received
        if health<=0 then
            alive=false
            player.give_points(30)
        end
    end

    local function draw()
        local x_flip=frame>4
        if damaged_since<15 then pal(4,2) end
        spr(2,x,y,1,1,x_flip,false)
        pal()
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


