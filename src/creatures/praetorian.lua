

function praetorian(x,y)
    local frame=1
    local x=x
    local y=y
    local damaged_since=60
    local health=80
    local alive=true
    local creature_damage=1
    local hitbox={x={4,12},y={2,14}}
    local spitting=false
    local spit

    local function update()
        if playing then
            y+=1
            if not spitting and frame%20==0 then y+=1 end
        end
        if not spitting then x_flip=frame>20 end
        if not spitting then frame=frame%40+1 end

        for player in all(players) do
            if abs(x-player.x()-4)<20 and player.y()-y<20 then
                if not spitting then
                    projectiles.spit_spit("praet_spit",x,y+16)
                    spitting=true
                end
            end
        end
        damaged_since=min(damaged_since+1,1000)
    end

    local function damage(damage_received,player)
        sfx(33)
        damaged_since=0
        health-=damage_received
        if health<=0 then
            alive=false
            projectiles.spit_spit("praet_cloud",x,y)
            del(spits,spit)
            player.give_points(100)
        end
    end

    local function draw()
        local x_flip=frame>20
        if damaged_since<15 then pal(3,2) end
        spr(3,x,y,2,2,x_flip,false)
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


