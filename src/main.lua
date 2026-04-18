

function _init()
    -- hacky stuff start
    music(-1,0,0)
    music(56,0,0)
    -- hacky stuff end

    -- cartdata layout
    -- 01 | haz 1 singleplayer
    -- 02 | haz 2 singleplayer
    -- 03 | haz 3 singleplayer
    -- 04 | haz 4 singleplayer
    -- 05 | haz 5 singleplayer
    -- 06 | haz 1 multiplayer
    -- 07 | haz 2 multiplayer
    -- 08 | haz 3 multiplayer
    -- 09 | haz 4 multiplayer
    -- 10 | haz 5 multiplayer
    -- 11 | player 1 last class
    -- 12 | player 2 last class
    -- 13 | last difficulty
    cartdata("oatbreadsdrillerdash")
    coop=false

    local roles={"driller","gunner","engineer"}
    last_player_1_class=dget(11) and roles[dget(11)] or "driller"
    last_player_2_class=dget(12) and roles[dget(12)] or "gunner"

    player_1=new_player(1,last_player_1_class)
    player_2=new_player(2,last_player_2_class)
    players={player_1}
    if coop then add(players,player_2) end
    projectiles=new_projectiles()
    resources=new_resources()
    creatures=new_creatures()
    map=new_map()
    hud=new_hud()
    props=new_props()

    title_screen=new_title_screen()
    death_screen=new_death_screen()
    game_logic=new_game_logic()

    performance_monitor=new_performance_monitor()

    at_title_screen=true
    playing=false
    at_death_screen=false
end

function _update()
    -- hacky stuff start
    -- hacky stuff end

    performance_monitor.reset_cpu_load()
    if not at_death_screen then
        projectiles.update()
        resources.update()
        map.update()
        player_1.update()
        if coop then player_2.update() end

        creatures.update()
        props.update()
        game_logic.update()
    else
        death_screen.calculate_death_screen()
    end

    performance_monitor.register_load()
end

function _draw()
    cls(1)
    camera(101,101)
    map.draw_terrain()
    map.draw_wall()
    map.draw_obstacles()
    props.draw_props()
    map.draw_drilled_ground()
    resources.draw()
    creatures.draw()
    projectiles.draw()
    if coop then player_2.draw() end
    player_1.draw()
    props.draw_particles()
    -- if at_title_screen then title_screen.draw() end
    map.draw_vines()
    map.draw_super_wall()
    hud.draw(player_1)
    if coop then hud.draw(player_2) end

    if at_death_screen then
        cls(1)
        map.draw_wall()
        map.draw_super_wall()
        if coop then player_2.draw() end
        player_1.draw()
        death_screen.draw()
        performance_monitor.print_summary()
    end

    performance_monitor.register_load()
    if playing then performance_monitor.print_current() end
end


