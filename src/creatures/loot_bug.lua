

function loot_bug(x,y)
    local frame=1
    local x=x
    local y=y
    local damaged_since=60
    local health=30
    local alive=true
    local creature_damage=0
    local hitbox={x={2,7},y={1,7}}

    local function update()
        if game_status=="playing" then
            y+=1
            if frame%30==0 then y+=1 end
        end
        damaged_since+=1
        frame=frame%60+1
    end

    local function damage(damage_received,player)
        sfx(33)
        damaged_since=0
        health-=damage_received
        if health<=0 then
            alive=false
            player.give_ammo(.2)
            no_lootbugs_killed=false
            add_killed_lootbug_name()
        end
    end

    local function draw()
        local sprite=30
        local x_flip=frame>30
        if damaged_since<15 then pal(15,2) end
        spr(sprite,x,y,1,1,x_flip,false)
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


