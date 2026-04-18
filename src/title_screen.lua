

-- file used to display everything title screen
function new_title_screen()
    local x0=170
    local y0=140
    resources.spawn_resource(x0,y0,"nitra")
    resources.spawn_resource(x0-2,y0+20,"gold")
    resources.spawn_resource(x0+14,y0+15,"red_sugar")

    x0=180
    y0=120
    creatures.spawn_creature(120,150,loot_bug)
    creatures.spawn_creature(130,150,cave_angel)
    creatures.spawn_creature(x0,y0,grunt)
    creatures.spawn_creature(x0+10,y0,slasher)
    creatures.spawn_creature(x0+18,y0,praetorian)
    creatures.spawn_creature(x0+34,y0,mactera)

    x0=200
    y0=160
    map.spawn_obstacle(nil,x0,y0,2)
    map.spawn_obstacle(nil,x0,y0-5,1)

    -- difficulty selection and class selection
    x0=180
    y0=180
    resources.spawn_menu_item(x0,y0,48,"class","driller")
    resources.spawn_menu_item(x0+15,y0,32,"class","gunner")
    resources.spawn_menu_item(x0+30,y0,34,"class","engineer")

    x0=118
    y0=170
    resources.spawn_menu_item(x0,y0,192,"number",1)
    resources.spawn_menu_item(x0+15,y0,193,"number",2)
    resources.spawn_menu_item(x0+30,y0,194,"number",3)
    resources.spawn_menu_item(x0+45,y0,195,"number",4)
    resources.spawn_menu_item(x0+60,y0,196,"number",5)

    local last_diff=dget(13)
    last_diff=last_diff==0 and 1 or last_diff
    resources.spawn_menu_item(148,198,191+last_diff,"number",last_diff)

    -- controls guide
    x0=190
    y0=200
    map.spawn_obstacle(227,x0,y0,2,false,false)
    map.spawn_obstacle(229,x0+16,y0,2,false,false)

    -- banner
    x0=105
    y0=105
    map.spawn_obstacle(199,x0,   y0,   4,false,false)
    map.spawn_obstacle(203,x0+32,y0,   4,false,false)
    map.spawn_obstacle(207,x0+64,y0,   1,false,false)
    map.spawn_obstacle(223,x0+64,y0+8, 1,false,false)
    map.spawn_obstacle(239,x0+64,y0+16,1,false,false)
    map.spawn_obstacle(255,x0+64,y0+24,1,false,false)
    map.spawn_obstacle(208,x0+10,y0+32,1,false,false)
    map.spawn_obstacle(209,x0+18,y0+32,1,false,false)
    map.spawn_obstacle(210,x0+26,y0+32,1,false,false)
    map.spawn_obstacle(211,x0+34,y0+32,1,false,false)
    map.spawn_obstacle(212,x0+42,y0+32,1,false,false)
end


