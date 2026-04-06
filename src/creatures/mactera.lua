

function mactera(x,y)
    local frame=sample_one(1,60)
    local spit_countdown=sample_one(15,30)
    local x=x
    local y=y
    local damaged_since=60
    local health=20
    local alive=true
    local did_spit=false
    local performing_spit=false
    local creature_damage=0
    local hitbox={x={2,7},y={1,7}}
    local tracked_player=choose_one(players)

    local function update()
        if did_spit then
        -- did already spit, fly along
            y+=1
            if frame%2==0 then y+=1 end
        elseif performing_spit then
        -- currently spitting, perform spit animation
            if frame%2==0 then x-=sgn(x-tracked_player.x()) end
            spit_countdown-=1
            if spit_countdown==1 then
                did_spit=true
                performing_spit=false
                projectiles.spit_spit("mactera_spit",x,y)
            end
        else
        -- currently homing
            y+=1
            if frame%2==0 then
                y+=1
                x-=sgn(x-tracked_player.x())
            end
            performing_spit=tracked_player.y()-y<30
        end
        damaged_since=min(damaged_since+1,1000)
        frame=frame%16+1
    end

    local function damage(damage_received,player)
        sfx(33)
        damaged_since=0
        health-=damage_received
        if health<=0 then
            alive=false
            no_cave_angels_killed=false
            player.give_points(30)
        end
    end

    local function draw()
        local sprite=17
        -- change to wings closed sprite
        if frame>8 then sprite+=1 end
        if damaged_since<15 then pal(3,2) end
        spr(sprite,x,y)
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


