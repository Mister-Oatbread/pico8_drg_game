

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
    -- map.add_obstacle({sprite=101,x=200,y=160,
    --     size=2,x_flip=false,y_flip=false})
    -- map.add_obstacle({sprite=84,x=200,y=155,
    --     size=1,x_flip=false,y_flip=true})

    -- difficulty selection and class selection
    local res_list=resources.get_resources
    local x0=120
    local y0=160
    res_list.add(resources.spawn_menu_item(x0,y0,48,"class","driller"))
    res_list.add(resources.spawn_menu_item(x0+15,y0,32,"class","gunner"))
    res_list.add(resources.spawn_menu_item(x0+30,y0,34,"class","engineer"))

    x0=170
    y0=170
    res_list.add(resources.spawn_menu_item(x0,y0,192,"number",1))
    res_list.add(resources.spawn_menu_item(x0+8,y0,193,"number",2))
    res_list.add(resources.spawn_menu_item(x0+16,y0,194,"number",3))
    res_list.add(resources.spawn_menu_item(x0+24,y0,195,"number",4))
    res_list.add(resources.spawn_menu_item(x0+32,y0,196,"number",5))

    -- controls guide
    x0=160
    y0=200

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
    map.add_obstacle({
        sprite=208,
        x=x0+10,
        y=y0+32,
        size=1,
        x_flip=false,
        y_flip=false,
    })
    map.add_obstacle({
        sprite=209,
        x=x0+18,
        y=y0+32,
        size=1,
        x_flip=false,
        y_flip=false,
    })
    map.add_obstacle({
        sprite=210,
        x=x0+26,
        y=y0+32,
        size=1,
        x_flip=false,
        y_flip=false,
    })
    map.add_obstacle({
        sprite=211,
        x=x0+34,
        y=y0+32,
        size=1,
        x_flip=false,
        y_flip=false,
    })
    map.add_obstacle({
        sprite=212,
        x=x0+42,
        y=y0+32,
        size=1,
        x_flip=false,
        y_flip=false,
    })
end


