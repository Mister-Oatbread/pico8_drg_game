

function egg(x,y)
    local frame=0
    local damaged_since=0
    local was_damaged=false
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
        display_alt=frame>10
        was_damaged,damaged_since=handle_creature_being_damaged(
            was_damaged,damaged_since)
        frame = (frame+1)%20
    end

    local function damage(damage_received)
        sfx(32)
        was_damaged=true
        health-=damage_received
        if health<=0 then
            give_ammo(.5)
            give_health(1)
            player.points+=50
            no_scout_killed=false
            alive=false
        end
    end

    local function draw()
        local sprite=58
        if display_alt then sprite+=1 end
        if was_damaged then sprite+=2 end
        spr(sprite,x,y)
    end

    local function x() return x end
    local function y() return y end
    local function is_alive() return alive end

    return {
        x=x,
        y=y,
        update=update,
        damage=damage,
        creature_damage=creature_damage,
        draw=draw,
        hitbox=hitbox,
        is_alive=is_alive,
    }
end


