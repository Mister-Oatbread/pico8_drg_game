

-- file used to display everything title screen
function new_death_screen()
    local loot_bug_names={
        "steeve",
        "jimini",
        "jebediah",
        "david",
        "eva",
        "lloyd",
        "molly",
        "randy",
        "jimothy",
        "geoff",

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
    }
    local killed_loot_bugs=new_entity_container()

    local function initialize()
    end

    local function report_killed_lootbug()
        killed_loot_bugs.add(choose_one(loot_bug_names))
    end

    local function draw()
        -- cleaning up game state
        sfx(-1,0)
        sfx(-1,1)
        sfx(-1,2)
        sfx(-1,3)
        -- player.is_moving.up=false
        -- player.is_moving.down=false
        -- player.is_moving.left=false
        -- player.is_moving.right=false
        -- player.is_drilling=false
        -- player.is_hit=false
        player.x_pos=130
        player.y_pos=182

        print("awards:", 111,126,7)
        print("",113,126,7)
        if no_lootbugs_killed then
            print("-no lootbugs")
            print(" killed (+100)")
        end
        if no_cave_angels_killed then
            print("-no cave angels")
            print(" killed (+100)")
        end
        if no_scout_killed then
            print("-you spared")
            print(" the scouts (+100)")
        end
        if in_tutorial then
            print("-died during the")
            print(" tutorial (+500)")
        end
        -- if not no_lootbugs_killed then
        if not no_lootbugs_killed then
            print("killed",190,130,7)
            print("loot")
            print("bugs:")
            local y = 148
            for name in all(killed_loot_bugs) do
                print(name,192,y)
                y+=6
            end
        end
        local points_total=0
        for i=1,#players do points_total+=players[i].points() end
        print("game over!", 120, 105, 7)
        print("score: "..points_total)
        print("distance travelled: "..game_time)
    end

    return {
        initialize=initialize,
        report_killed_lootbug=report_killed_lootbug,
        draw=draw,
    }
end


