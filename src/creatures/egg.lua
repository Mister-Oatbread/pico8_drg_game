

function egg(x,y)
    local frame=1
    local damaged_since=60
    local x=x
    local y=y
    local display_alt=false
    local health=30
    local alive=true
    local creature_damage=0
    local hitbox={x={2,7},y={1,8}}

    local function update()
        y+=1
        if frame%5==0 then y-=1 end
        display_alt=frame>5
        damaged_since+=1
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
            no_scout_killed=false
            alive=false
        end
    end

    local function draw()
        local sprite=51
        if display_alt then sprite+=1 end
        if damaged_since<15 then pal(12,2) end
        spr(sprite,x,y,1,1,display_alt,false)
        pal()
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


