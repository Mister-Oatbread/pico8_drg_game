

function mactera(x,y)
    local frame=1
    local x=x
    local y=y
    local damaged_since=60
    local wings_open=false
    local health=20
    local alive=true
    local did_spit=false
    local perform_spit=false
    local creature_damage=0
    local hitbox={x={2,7},y={1,7}}

    -- TODO: rework this bozo

    local function update()
        if game_status=="playing" then
            if (player.y_pos-y)<30 and not did_spit then
                perform_spit=true
            end
            if perform_spit then
                if frame==0 then
                    did_spit=true
                    add_spit("mactera_spit",x,y)
                end
                if did_spit and frame==0 then
                    perform_spit=false
                end
            else
                y+=1
                if frame%2==0 then y+=1 end
            end
            if frame%2==0 and not did_spit then x-=sgn(x-player.x_pos) end
        end
        damaged_since+=1
        wings_open=frame>8
        frame=frame%16+1
    end

    local function damage(damage_received)
        sfx(33)
        damaged_since=0
        health-=damage_received
        if health<=0 then
            alive=false
            no_cave_angels_killed=false
            player.points+=30
        end
    end

    local function draw()
        local sprite=27
        if wings_open then sprite+=1 end
        if damaged_since<15 then sprite+=2 end
        spr(sprite,x,y)
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


