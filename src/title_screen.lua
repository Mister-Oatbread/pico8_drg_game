

-- file used to display everything title screen
function new_title_screen()
    -- add(resources, {sprite=65, x_coord=151, y_coord=170,
    --     x_flip=rnd(2)<1, y_flip=rnd(2)<1, hitbox=nitra_hitbox})
    -- add(resources, {sprite=82, x_coord=148, y_coord=190,
    --     x_flip=rnd(2)<1, y_flip=rnd(2)<1, hitbox=gold_hitbox})
    -- add(resources, {sprite=64, x_coord=164, y_coord=185,
    --     x_flip=rnd(2)<1, y_flip=rnd(2)<1, hitbox=red_sugar_hitbox})
    -- add(creatures, loot_bug(190, 180))
    -- add(creatures, cave_angel(182, 165))
    -- add(creatures, grunt(180, 120))
    -- add(creatures, slasher(190, 120))
    -- add(creatures, praetorian(200, 120))
    -- add(creatures, mactera(218, 120))
    map.add_obstacle({sprite=101,x=200,y=160,
        size=2,x_flip=false,y_flip=false})
    map.add_obstacle({sprite=84,x=200,y=155,
        size=1,x_flip=false,y_flip=true})

    -- controls guide
    local x0=160
    local y0=200

    map.add_obstacle({
        sprite=227,
        x=x0,
        y=y0,
        size=2,
        x_flip=false,
        y_flip=false,
    })
    map.add_obstacle({
        sprite=229,
        x=x0+16,
        y=y0,
        size=2,
        x_flip=false,
        y_flip=false,
    })

    -- banner
    x0=105
    y0=105
    map.add_obstacle({
        sprite=199,
        x=x0,
        y=y0,
        size=4,
        x_flip=false,
        y_flip=false,
    })
    map.add_obstacle({
        sprite=203,
        x=x0+32,
        y=y0,
        size=4,
        x_flip=false,
        y_flip=false,
    })
    map.add_obstacle({
        sprite=207,
        x=x0+64,
        y=y0,
        size=1,
        x_flip=false,
        y_flip=false,
    })
    map.add_obstacle({
        sprite=223,
        x=x0+64,
        y=y0+8,
        size=1,
        x_flip=false,
        y_flip=false,
    })
    map.add_obstacle({
        sprite=239,
        x=x0+64,
        y=y0+16,
        size=1,
        x_flip=false,
        y_flip=false,
    })
    map.add_obstacle({
        sprite=255,
        x=x0+64,
        y=y0+24,
        size=1,
        x_flip=false,
        y_flip=false,
    })
end


