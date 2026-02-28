

function praetorian(x,y)
    local frame=1
    local x=x
    local y=y
    local damaged_since=0
    local x_flip=false
    local was_damaged=false
    local health=80
    local alive=true
    local creature_damage=1
    local hitbox={x={4,12},y={2,14}}
    local spitting=false
    local spit

    local function update()
        if game_status=="playing" then
            y+=1
            if not spitting and frame%20==0 then y+=1 end
        end
        if not spitting then x_flip=frame>20 end
        was_damaged,damaged_since=handle_creature_being_damaged(
            was_damaged,damaged_since)
        frame=frame%40+1
        if abs(x-player.x()-4)<20 and player.y()-y<20 then
            if not spitting then
                add_spit("praet_spit",x,y+16)
                spitting=true
            end
        end
    end

    local function damage(damage_received)
        sfx(33)
        was_damaged=true
        health-=damage_received
        if health<=0 then
            alive=false
            add_spit("praet_cloud",x,y)
            del(spits,spit)
            player.points+=100
        end
    end

    local function draw()
        local sprite=3
        if was_damaged then sprite+=2 end
        spr(sprite,x,y,2,2,x_flip,false)
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


