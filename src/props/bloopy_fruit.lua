

-- function squishy_thingy(x, y)
--     local x=x
--     local y=y
--     local x_flip=coinflip()
--     local y_flip=coinflip()
--
--     local sprite=sample_one(178,181)
--
--     return {
--         x=function() return x end,
--         y=function() return y end,
--         update=function() y+=1 end,
--         draw=function() spr(sprite,x,y,1,1,x_flip,y_flip) end,
--         hitbox=function() return {x={3,6},y={3,6}} end,
--     }
-- end

function spawn_squishy_thing(x,y)
    squishy_ratios={
        {1,"bloopy"},
        {1,"oripricot"},
        {1,"pulsa_stickpod"},
    }
    squishy_spawn_params=generate_spawn_params(squishy_ratios,#squishy_ratios)

    local choice = pick_spawn(squishy_spawn_params)
    local sprite

    if choice == "bloopy" then
        sprite=sample_one(176,179)
    elseif choice == "oripricot" then
        sprite=sample_one(160,163)
    elseif choice == "pulsa_stickpod" then
        sprite=sample_one(144,147)
    end

    squishy_stuff.add({
        x=x,
        y=y,
        x_flip=coinflip(),
        y_flip=coinflip(),
        sprite=sprite,
    })
end

function draw_squishy_stuff()
    local squisher
    for i=1,squishy_stuff.size() do
        squisher=squishy_stuff.get(i)
        spr(
            squisher.sprite,
            squisher.x,
            squisher.y,
            1,
            1,
            squisher.x_flip,
            squisher.y_flip
        )
    end
end


