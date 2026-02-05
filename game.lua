

-- contains all sorts of miscellaneous things related to the game itself
function initialize_game()
    damaged_sprite_duration = 4;
    game_time = 0;
end

function update_game()
    game_time += 1;
    if game_time%5==0 then player.points += 1 end;
end

