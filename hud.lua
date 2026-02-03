

-- this file contains all hud elements
function initialize_hud()
    hud_sprites = {health=45,ammo=46,fuel=47};
end

function draw_hud()
    print(
        "health: "..player.health..
        " ammo: "..player.ammo..
        " fuel: "..player.fuel,
        110, 220,7)
end


