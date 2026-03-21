

-- file used to display everything title screen
function new_title_screen()

    local function initialize()

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
        map.add_obstacle({sprite=101,x_coord=200,y_coord=160,
            size=2,x_flip=false,y_flip=false})
        map.add_obstacle({sprite=84,x_coord=200,y_coord=155,
            size=1,x_flip=false,y_flip=true})
    end

    -- controls guide
    local function draw_controls()
        local x0=160
        local y0=200
        spr(227,x0+16,y0,2,2)
        spr(229,x0,y0,2,2)

        map.add_obstacle({
            sprite=229,
            x=x0+16,
            y=y0,
            size=2,
            x_flip=false,
            y_flip=false})
    end

    local function draw()
        draw_controls()
    end

    return {
        initialize=initialize,
        draw=draw,
    }
end


