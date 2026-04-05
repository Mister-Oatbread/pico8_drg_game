

function orchey_shy(x, y)
    local x=x
    local y=y
    local x_flip=coinflip()
    local y_flip=coinflip()

    local function draw()
        local sprite
        local distance=10000

        -- find smaller distance
        for player in all(players) do
            distance=min((player.x()-x)^2 + (player.y()-y)^2,distance)
        end
        sprite=188
        if distance<225 then
            sprite=190
        elseif distance<900 then
            sprite=189
        end
        spr(sprite,x,y,1,1,x_flip,y_flip)
    end

    return {
        x=function() return x end,
        y=function() return y end,
        update=function() y+=1 end,
        draw=draw,
        draw_particles=function() end,
    }
end
