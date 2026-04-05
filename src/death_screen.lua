

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
        "thorben",

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
    local no_cave_angels_killed=true
    local no_eggs_killed=true

    local function draw()
        local points_total=0
        local no_lootbugs_killed=killed_loot_bugs.size()==0
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
        for player in all(players) do
            player.x=130+8*(player.number()-1)
            points_total+=player.points()
        end

        print("awards:", 111,126,7)
        print("",113,126,7)
        if no_lootbugs_killed then
            print("-no lootbugs")
            print(" killed (+100)")
            points_total+=100
        end
        if no_cave_angels_killed then
            print("-no cave angels")
            print(" killed (+100)")
            points_total+=100
        end
        if no_scout_killed then
            print("-you spared")
            print(" the scouts (+100)")
            points_total+=100
        end
        if at_title_screen then
            print("-died during the")
            print(" tutorial (+500)")
            points_total+=500
        end
        -- if not no_lootbugs_killed then
        if not no_lootbugs_killed then
            print("killed",190,130,7)
            print("loot")
            print("bugs:")
            local y = 148
            for i=1,killed_loot_bugs.size() do
                print(killed_loot_bugs[i],192,y)
                y+=6
            end
        end
        print("game over!", 120, 105, 7)
        print("score: "..points_total)
        -- print("distance travelled: "..game_time)
    end

    local function report_killed_lootbug()
        killed_loot_bugs.add(choose_one(loot_bug_names))
    end

    return {
        report_killed_lootbug=report_killed_lootbug,
        report_killed_cave_angel=function() no_cave_angels_killed=false end,
        report_killed_egg=function() no_eggs_killed=false end,
        draw=draw,
    }
end


