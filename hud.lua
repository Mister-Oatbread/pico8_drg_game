

-- this file contains all hud elements
function initialize_hud()
    hud_sprites = {health=45,ammo=46,fuel=47,points=62};
end

function draw_hud()
    spr(hud_sprites.health,105,180);
    spr(hud_sprites.ammo,105,190);
    spr(hud_sprites.fuel,105,200);
    spr(hud_sprites.points,105,210);

    print(player.health, 115,181,7);
    print(player.ammo, 115,191,7);
    print(flr(player.fuel/10), 115,201,7);
    print(player.points, 115,211,7);
end


