

-- this file contains all hud elements
function initialize_hud()
    hud_sprites = {heart=45,empty_heart=63,ammo=46,fuel=47,points=62};
    prog_bar_sprite = 61;
    number_sprites = {192,193,194,195,196};
    loot_bug_names = {
        "steeve",
        "jimini",
        "jebediah",
        "david",
        "eva",
        "lloyd",
        "molly",
        "randy",

        "emilia",
        "olliver",
        "matilda",
        "benjamin",
        "elodie",
        "julien",
        "amelia",
        "sebby",
        "charlie",
        "rosalie",
        "freddie",
        "isabelle",
        "tobias",
        "lucien",
        "henry",
        "maxime",
        "oliver",
        "samuel",
        "august",
        "finnley",

        "steevie",
    };
    killed_loot_bugs = {};
    haz_level_selection = 3;

    -- add banner
    local x0 = 105;
    local y0 = 120;
    add(obstacles, {
        sprite=199,
        x_coord=x0,
        y_coord=y0,
        size=4,
        false,
        false});
    add(obstacles, {
        sprite=203,
        x_coord=x0+32,
        y_coord=y0,
        size=4,
        false,
        false});
    add(obstacles, {
        sprite=207,
        x_coord=x0+64,
        y_coord=y0,
        size=4,
        false,
        false});
    add(obstacles, {
        sprite=224,
        x_coord=140,
        y_coord=213,
        size=3,
        false,
        false});

    -- controls guide
    x0 = 160;
    y0 = 200;
    add(obstacles, {
        sprite=227,
        x_coord=x0,
        y_coord=y0,
        size=2,
        x_flip=false,
        y_flip=false});
    add(obstacles, {
        sprite=229,
        x_coord=x0+16,
        y_coord=y0,
        size=2,
        x_flip=false,
        y_flip=false});

    -- tutorial sprites
    add(resources, {sprite=65, x_coord=151, y_coord=170,
        x_flip=rnd(2)<1, y_flip=rnd(2)<1, hitbox=nitra_hitbox});
    add(resources, {sprite=82, x_coord=148, y_coord=190,
        x_flip=rnd(2)<1, y_flip=rnd(2)<1, hitbox=gold_hitbox});
    add(resources, {sprite=64, x_coord=164, y_coord=185,
        x_flip=rnd(2)<1, y_flip=rnd(2)<1, hitbox=red_sugar_hitbox});
    add(creatures, loot_bug(190, 180));
    add(creatures, cave_angel(182, 165));
    add(creatures, grunt(180, 120));
    add(creatures, slasher(190, 120));
    add(creatures, praetorian(200, 120));
    add(creatures, mactera(218, 120));
    add(obstacles, {sprite=101,x_coord=200,y_coord=160,
        size=2,x_flip=false,y_flip=false});
    add(obstacles, {sprite=84,x_coord=200,y_coord=155,
        size=1,x_flip=false,y_flip=true});

    -- add numbers for haz level selection
    x0 = 128;
    y0 = 160;
    add(creatures, number(x0,y0,1));
    add(creatures, number(x0+10,y0,2));
    add(creatures, number(x0+20,y0,3));
    add(creatures, number(x0+30,y0,4));
    add(creatures, number(x0+40,y0,5));
end

function draw_hud()
    _draw_hearts();
    spr(hud_sprites.ammo,105,190);
    spr(hud_sprites.fuel,105,200);
    spr(hud_sprites.points,105,210);

    _draw_prog_bar(player.ammo/player.max_ammo,112,192);
    _draw_prog_bar(player.fuel/player.max_fuel,112,202);
    print(player.points, 115,211,7);
end

-- takes a percentage, as well as x and y position, and paints a prog bar
function _draw_prog_bar(percentage, x_coord, y_coord)
    local green_pixels = flr(percentage*10);
    local color;

    spr(prog_bar_sprite,x_coord, y_coord);
    spr(prog_bar_sprite,x_coord+5, y_coord);

    for x=1,10 do
        if x<=green_pixels then color=11 else color=8 end;
        pset(x_coord+x,y_coord+1,color);
    end
end

-- randomly draws a name from the killed loot bugs for the death screen
function add_killed_lootbug_name()
    add(killed_loot_bugs, loot_bug_names[flr(rnd(#loot_bug_names))]);
end

-- draw up to three hearts representing player health
function _draw_hearts()
    local x0 = 105;
    local y0 = 180;

    local hearts = {hud_sprites.heart, hud_sprites.heart, hud_sprites.heart};
    if player.health < 1 then
        hearts[1] = hud_sprites.empty_heart;
    end
    if player.health < 2 then
        hearts[2] = hud_sprites.empty_heart;
    end
    if player.health < 3 then
        hearts[3] = hud_sprites.empty_heart;
    end
    spr(hearts[1],x0,y0);
    spr(hearts[2],x0+8,y0);
    spr(hearts[3],x0+16,y0);
end

-- post game summary
function display_death_screen()
    -- cleaning up game state
    sfx(-1,0);
    sfx(-1,1);
    sfx(-1,2);
    sfx(-1,3);
    player.is_moving.up = false;
    player.is_moving.down = false;
    player.is_moving.left = false;
    player.is_moving.right = false;
    player.is_drilling = false;
    player.is_hit = false;
    player.x_pos = 130;
    player.y_pos = 182;

    print("game over!", 120, 105, 7);
    print("score: "..player.points);
    print("distance travelled: "..game_time);
    print("awards:", 111,126,7);
    print("",113,126,7);
    if no_lootbugs_killed then
        print("-no lootbugs");
        print(" killed");
    end
    if no_cave_angels_killed then
        print("-no cave");
        print(" angels killed");
    end
    if no_driller_drilled then
        print("-you spared");
        print(" the drillers");
    end
    if player.points==0 then
        print("-died during");
        print(" the tutorial");
    end
    -- if not no_lootbugs_killed then
    if not no_lootbugs_killed then
        print("names of",180,120,7);
        print("killed");
        print("loot bugs:");
        local y = 138;
        for name in all(killed_loot_bugs) do
            print(name,182,y);
            y+=6;
        end
    end
end

function display_chefs_kiss_banner()
    local x0 = 105;
    local y0 = 120;

    spr(199, x0, y0, 4, 4);
    spr(203, x0+32, y0, 4, 4);
    spr(207, x0+64, y0, 4, 4);
    print("shoot haz level:",105,152,9);
end


