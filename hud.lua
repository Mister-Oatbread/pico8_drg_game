

-- this file contains all hud elements
function initialize_hud()
    hud_sprites = {health=45,ammo=46,fuel=47,points=62};
end

function draw_hud()
    spr(hud_sprites.health,105,190);
    spr(hud_sprites.ammo,105,200);
    spr(hud_sprites.fuel,105,210);
    spr(hud_sprites.points,105,220);

    print(player.health, 115,191);
    print(player.ammo, 115,201);
    print(flr(player.fuel/10), 115,211);
    print(player.points, 115,221);
end


