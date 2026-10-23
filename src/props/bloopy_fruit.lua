

function bloopy_fruit(x,y)
    local x=x
    local y=y
    local x_flip=coinflip()
    local y_flip=coinflip()
    local sprite=sample_one(178,181)

    return {
        update=function() y+=1 end,
        draw=function() spr(sprite,x,y,1,1,x_flip,y_flip) end,
        hitbox=function() return {x={3,6},y={3,6} end,
    }
end


