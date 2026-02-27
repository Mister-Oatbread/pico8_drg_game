

function loot_bug(x,y)
    local x=x
    local y=y
    local damaged_since=0
    local was_damaged=false
    local x_flip=false
    local health=30
    local alive=true
    local creature_damage=0
    local hitbox={x={2,7},y={1,7}}

    local function update()
        if game_status=="playing" then
            y+=1
            if frame%27==26 then y+=1 end
        end
        x_flip=frame>15
        was_damaged,damaged_since=handle_creature_being_damaged(
            was_damaged,damaged_since)
        frame=(frame+1)%30
    end

    local function damage(damage_received)
        sfx(33)
        was_damaged=true
        health-=damage_received
        if health<=0 then
            alive=false
            give_ammo(.2)
            no_lootbugs_killed=false
            add_killed_lootbug_name()
        end
    end

    local function draw()
        local sprite=44
        if was_damaged then sprite+=1 end
        spr(sprite,x,y,1,1,x_flip,false)
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


