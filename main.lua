

function _init()
    initialize_map();
    initialize_obstacles();
    initialize_player();
end

function _update()
    update_map();
    update_obstacles();
    move_player();
end

function _draw()
    cls();
    camera(101,101);
    draw_map();
    draw_obstacles();
    draw_player();
end


