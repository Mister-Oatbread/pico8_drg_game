

function number(x,y,value)
    local value=value
    local x = x
    local y = y
    local health = 1
    local alive = true
    local creature_damage = 0
    local hitbox={x={3,7},y={1,8}}

    local function update()
        if game_status=="playing" then y+=1 end
    end

    local function damage(damage_received)
        sfx(33)
        health-=damage_received
        if health<=0 then
            difficulty=value
            set_hazard_level()
            in_tutorial=false
            game_status="playing"
            -- cut music and start playing new music
            music(-1)
            music(1)
            alive=false
        end
    end

    local function draw()
        local b={x={x+hitbox.x[1]-1, x+hitbox.x[2]-1}}
        local a={x={player.x_pos+6,player.x_pos+6}}
        local sprite=191+value
        if a.x[1]>b.x[2] or a.x[2]<b.x[1] then sprite+=16 end
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


