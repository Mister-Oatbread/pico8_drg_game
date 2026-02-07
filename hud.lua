

-- this file contains all hud elements
function initialize_hud()
    hud_sprites = {heart=45,empty_heart=63,ammo=46,fuel=47,points=62};
    prog_bar_sprite = 61;
    loot_bug_names = {
        "steeve",
        "jimini",
        "jebediah",
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
    local haz_level_selection = 3;
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
    rectfill(100,100,230,230,1);
    draw_wall();
    draw_super_wall();
    player.x_pos = 160;
    player.y_pos = 160;
    draw_player();
    draw_hud();
    print("game over!", 150, 105, 7);
    print("score: "..player.points);
    print("awards:", 111,120,7);
    print("",113,120,7);
    if no_lootbugs_killed then
        print("no lootbugs");
        print("killed");
    end
    if no_cave_angels_killed then
        print("no cave");
        print("angels killed");
    end
    if no_driller_drilled then
        print("you spared");
        print("the drillers");
    end
    -- if not no_lootbugs_killed then
    if true then
        print("names of",180,120,7);
        print("killed");
        print("loot bugs:");
        local y = 138;
        for name in all(killed_loot_bugs) do
            print(name,182,y);
            y+=6;
        end
    end
    stop("", 150, 150, 8);
end

-- lets you select hazard level
function update_haz_selector();
    if btnp(2) then haz_level_selection -= 1 end;
    if btnp(3) then haz_level_selection += 1 end;
    if haz_level_selection > 5 then haz_level_selection=1 end;
    if haz_level_selection < 1 then haz_level_selection=5 end;
end

function display_haz_selector();
    print("Choose a hazard level");
end


