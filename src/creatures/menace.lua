

function menace(x,y)
    local frame=0
    local x=x
    local y=y
    local x_flip=false
    local y_flip=false
    local damaged_since=60
    local health=60
    local alive=true
    local creature_damage=0
    local hitbox={x={1,8},y={1,8}}
    local tracked_player=choose_one(players)

    local function update()
        if playing then
            y+=1
        end
        -- flip menace based on relative player position
        x_flip=tracked_player.x()-x>0
        y_flip=tracked_player.y()-y>0

        if frame%10==1 then
            local x_shot_position=x_flip and x+8 or x
            local y_shot_position=y_flip and y+8 or y
            local angle=atan2(
                tracked_player.x()-x_shot_position,
                tracked_player.y()-y_shot_position
            )
            local x_vel=2*cos(angle)
            local y_vel=2*sin(angle)+1
            projectiles.add_menace_spit(
                x_shot_position,
                y_shot_position,
                x_vel,
                y_vel
            )
        end
        frame=frame%10+1
        damaged_since+=1
    end

    local function damage(damage_received,player)
        sfx(33)
        damaged_since=0
        health-=damage_received
        x_flip=frame>6
        if health<=0 then
            alive=false
            player.give_points(10)
        end
    end

    local function draw()
        if damaged_since<15 then pal(12,2) end
        spr(11,x,y,1,1,x_flip,y_flip)
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


