

function _init()
    initialize_game();
    initialize_hud();
    initialize_map();
    initialize_obstacles();
    initialize_resources();
    initialize_creatures();
    initialize_player();
    initialize_bullets();
end

function _update()
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
end

function _draw()
    cls();
    camera(101,101);

    draw_map();
    draw_obstacles();
    draw_resources();
    draw_creatures();
    draw_player();
    draw_hud();
    draw_bullets();
end


