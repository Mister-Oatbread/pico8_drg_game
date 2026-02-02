

function _init()
    initialize_map();
    initialize_player();
end

function _update()
    update_map();
    move_player();
end

function _draw()
    cls();
    camera(101,101);
    draw_map();
    draw_player();
end


