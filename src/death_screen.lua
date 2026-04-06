

-- file used to display everything title screen
function new_death_screen()
    local loot_bug_names={
        "steeve",
        "steevie",
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
        "nil",
        "lisa",

        -- "emilia",
        -- "olliver",
        -- "matilda",
        -- "benjamin",
        -- "elodie",
        -- "julien",
        -- "amelia",
        -- "sebby",
        -- "charlie",
        -- "rosalie",
        -- "freddie",
        -- "isabelle",
        -- "tobias",
        -- "lucien",
        -- "henry",
        -- "maxime",
        -- "oliver",
        -- "samuel",
        -- "august",
        -- "finnley",
        --
        -- "omega",
    }
    local killed_loot_bugs=new_entity_container()
    local no_cave_angels_killed=true
    local no_eggs_killed=true

    local function draw()
        local points_total=0
        local no_loot_bugs_killed=killed_loot_bugs.size()==0
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
            player.reposition(130+8*player.number()-1,180)
            -- player.x()=130+8*(player.number()-1)
            points_total+=player.points()
        end

        print("awards:", 111,126,7)
        print("",113,126,7)
        print("-distance bonus")
        print(" (+"..game_logic.get_distance()..")")
        points_total+=game_logic.get_distance()
        if no_loot_bugs_killed then
            print("-no loot_bugs")
            print(" killed (+100)")
            points_total+=100
        end
        if no_cave_angels_killed then
            print("-no cave angels")
            print(" killed (+100)")
            points_total+=100
        end
        if no_eggs_killed then
            print("-you spared the")
            print(" scouts (+100)")
            points_total+=100
        end
        if at_title_screen then
            print("-died during the")
            print(" tutorial (+500)")
            points_total+=500
        end
        -- if not no_loot_bugs_killed then
        if not no_loot_bugs_killed then
            print("killed",190,130,7)
            print("loot")
            print("bugs:")
            local y = 148
            for i=1,killed_loot_bugs.size() do
                print(killed_loot_bugs.get(i),192,y)
                y+=6
            end
        end
        print("game over!", 120, 105, 7)
        print("score: "..points_total)
        local highscore_index=coop and hazard+5 or hazard
        local highscore=dget(highscore_index)
        print("highscore: "..highscore)
        if points_total>highscore then
            print("new highscore!!!")
            dset(highscore_index,points_total)
        end
        -- print("distance travelled: "..game_time)
    end

    local function report_killed_loot_bug()
        killed_loot_bugs.add(loot_bug_names[sample_one(1,#loot_bug_names)])
    end

    return {
        report_killed_loot_bug=report_killed_loot_bug,
        report_killed_cave_angel=function() no_cave_angels_killed=false end,
        report_killed_egg=function() no_eggs_killed=false end,
        draw=draw,
    }
end


