

function cave_angel(x,y)
    local frame=1
    local x=x
    local y=y
    local damaged_since=60
    local x_flip=rnd(2)<1
    local health=20
    local alive=true
    local creature_damage=0
    local hitbox={x={2,7},y={1,7}}
    local wings_open
    local tracked_player=choose_one(players)

    local function update()
        if playing then
            y+=1
            if frame%45==0 then x+=sgn(x-tracked_player.x()) end
            if frame%30==0 then y+=1 end
        end
        wings_open=frame>45
        damaged_since+=1
        frame=frame%60+1
    end

    local function damage(damage_received,player)
        sfx(33)
        damaged_since=0
        health-=damage_received
        if health<=0 then
            alive=false
            no_cave_angels_killed=false
        end
    end

    local function draw()
        local sprite=14
        if damaged_since<15 then pal(12,2) end
        if not wings_open then sprite+=1 end
        spr(sprite,x,y,1,1,x_flip,false)
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


