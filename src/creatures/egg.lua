

function egg(x,y)
    local frame=1
    local damaged_since=60
    local x=x
    local y=y
    local health=30
    local alive=true
    local creature_damage=0
    local hitbox={x={2,7},y={1,8}}

    local function update()
        y+=1
        if frame%5==0 then y-=1 end
        damaged_since=min(damaged_since+1,1000)
        frame=frame%10+1
    end

    local function damage(damage_received,player)
        sfx(32)
        health-=damage_received
        damaged_since=0
        if health<=0 then
            player.give_ammo(.5)
            player.give_health(1)
            player.give_points(50)
            death_screen.report_killed_egg()
            alive=false
        end
    end

    local function draw()
        local x_flip=frame>5
        if damaged_since<15 then pal(12,2) end
        spr(51,x,y,1,1,x_flip,false)
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


