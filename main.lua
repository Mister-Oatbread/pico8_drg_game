

function _init()
    initialize_game();
    initialize_map();
    initialize_obstacles();
    initialize_resources();
    initialize_creatures();
    initialize_hud();
    initialize_player();
    initialize_bullets();
end

function _update()
    if game_status == "title_screen" then
        update_inputs();
        update_obstacles();
        update_creatures();
        update_resources();
        move_player();
        handle_player_abilities();
        update_map();
        update_bullets();
        check_bullet_collision();
    elseif game_status == "playing" then
        update_inputs();
        update_game();
        update_map();
        update_obstacles();
        update_resources();
        update_creatures();
        move_player();
        handle_player_abilities();
        update_bullets();
        check_bullet_collision();
    elseif game_status == "end_screen" then
        if btn(4) and btn(5) then reboot() end;
    end
end

function _draw()
    cls();
    camera(101,101);
    if game_status == "title_screen" then
        draw_map();
        draw_wall();
        display_chefs_kiss_banner();
        -- display_tutorial();
        draw_obstacles();
        draw_resources();
        draw_super_wall();
        draw_bullets();
        draw_creatures();
        draw_player();
        -- drop pod
        spr(224,140,213,3,3);
        draw_hud();
        -- display_haz_selector();
        -- display_quick_guide();
    elseif game_status == "playing" then
        draw_map();
        draw_wall();
        draw_obstacles();
        draw_super_wall();
        draw_resources();
        draw_creatures();
        draw_bullets();
        draw_player();
        draw_hud();
    elseif game_status == "end_screen" then
        rectfill(100,100,230,230,1);
        draw_wall();
        draw_super_wall();
        draw_player();
        draw_hud();
        display_death_screen();
    end
end


