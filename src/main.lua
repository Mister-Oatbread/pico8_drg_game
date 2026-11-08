

function _init()
    music(-1,0,0)
    music(56,0,0)

    -- cartdata layout
    -- 01 | haz 1 singleplayer highscore
    -- 02 | haz 2 singleplayer highscore
    -- 03 | haz 3 singleplayer highscore
    -- 04 | haz 4 singleplayer highscore
    -- 05 | haz 5 singleplayer highscore
    -- 06 | haz 1 multiplayer highscore
    -- 07 | haz 2 multiplayer highscore
    -- 08 | haz 3 multiplayer highscore
    -- 09 | haz 4 multiplayer highscore
    -- 10 | haz 5 multiplayer highscore
    -- 11 | player 1 last class
    -- 12 | player 2 last class
    -- 13 | last difficulty

    cartdata("oatbreadsdrillerdash")
    coop=false

    local roles={"driller","gunner","engineer"}
    last_player_1_class=dget(11) and roles[dget(11)] or "driller"
    last_player_2_class=dget(12) and roles[dget(12)] or "gunner"

    -- terrain
    terrain=new_entity_container()
    walls=new_entity_container()
    super_walls=new_entity_container()
    drilled_ground=new_entity_container()
    obstacles=new_entity_container()
    squishy_stuff=new_entity_container()

    bullets=new_entity_container()
    spits=new_entity_container()

    resources=new_entity_container()

    player_1=new_player(1,last_player_1_class)
    player_2=new_player(2,last_player_2_class)
    players={player_1}
    if coop then
        add(players,player_2)
    end

    creatures=new_entity_container()
    for x=106,220,9 do
        creatures.add(bottom_grunt(x,222))
    end

    props=new_entity_container()

    initialize_title_screen()

    creature_spawn_params = 0
    obstacle_spawn_params = 0
    resource_spawn_params = 0
    timer=0
    hazard=1

    performance_monitor=new_performance_monitor()

    at_title_screen=true
    playing=false
    at_death_screen=false

    loot_bug_names={
        "steeve",
        "steevie",
        "jimini",
        "jebediah",
        "david",
        "eva",
        "lloyd",
        "molly",
        "randy",
        "jimothy",
        "geoff",
        "thorben",
        "nil",
        "lisa",
        "jeffeory",
        "zundolf",
        "morty",

        -- "emilia",
        -- "olliver",
        -- "matilda",
        -- "benjamin",
        -- "elodie",
        -- "julien",
        -- "amelia",
        -- "sebby",
        -- "charlie",
        -- "rosalie",
        -- "freddie",
        -- "isabelle",
        -- "tobias",
        -- "lucien",
        -- "henry",
        -- "maxime",
        -- "oliver",
        -- "samuel",
        -- "august",
        -- "finnley",
        --
        "omega",
    }

    killed_loot_bugs = new_entity_container()
    no_loot_bugs_killed = true
    no_cave_angels_killed = true
    no_eggs_killed = true
    points_total=0
    highscore=0
    death_screen_calculated=false

    -- initialize walls with random sprite
    for x=102,220,118 do
        for y=91,228,8 do
            walls.add(add_wall(x,y))
        end
    end

    -- initialize super walls
    for i=98,230,130 do
        for j=91,228,8 do
            super_walls.add({x=i,y=j})
        end
    end
end

function _update()
    -- hacky stuff start
    -- hacky stuff end

    performance_monitor.reset_cpu_load()
    if not at_death_screen then
        update_projectiles()
        update_resources()
        update_map()
        player_1.update()
        if coop then player_2.update() end

        update_creatures()
        update_props()
        update_game()
    else
        calculate_death_screen()
    end

    performance_monitor.register_load()
end

function _draw()
    cls(1)
    camera(101,101)
    draw_squishy_stuff()
    draw_base_map()
    draw_walls()
    draw_props()
    draw_drilled_ground()
    draw_resources()
    draw_creatures()
    draw_projectiles()
    if coop then player_2.draw() end
    player_1.draw()
    draw_particles()
    -- if at_title_screen then title_screen.draw() end
    draw_super_wall()
    draw_hud()

    if at_death_screen then
        cls(1)
        draw_walls()
        draw_super_wall()
        if coop then player_2.draw() end
        player_1.draw()
        draw_death_screen()
        performance_monitor.print_summary()
    end

    performance_monitor.register_load()
    if playing then performance_monitor.print_current() end
end


