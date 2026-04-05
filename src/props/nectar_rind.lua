

function nectar_rind(x,y)
    local x=x
    local y=y
    local x_flip = coinflip()
    local y_flip = coinflip()

    local function draw()
        local sprite=172
        -- check if one of the players is in reach
        for player in all(players) do
            if ((player.x()-x)^2 + (player.y()-y)^2) < 30^2 then
                sprite=173
            end
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


