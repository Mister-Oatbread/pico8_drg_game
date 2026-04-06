

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
        "omega",
    }
    local killed_loot_bugs=new_entity_container()
    local no_loot_bugs_killed=true
    local no_cave_angels_killed=true
    local no_eggs_killed=true
    local points_total=0
    local highscore=0
    local death_screen_calculated=false

    -- determines certain parameters for the death screen
    local function calculate_death_screen()
        if not death_screen_calculated then
            no_loot_bugs_killed=killed_loot_bugs.size()==0
            for player in all(players) do
                player.reposition(120+8*player.number()-1,193)
                -- player.x()=130+8*(player.number()-1)
                points_total+=player.points()
            end
            points_total+=game_logic.get_distance()
            if no_loot_bugs_killed then points_total+=100 end
            if no_cave_angels_killed then points_total+=100 end
            if no_eggs_killed then points_total+=100 end
            if at_title_screen then points_total+=500 end
            local highscore_index=game_logic.hazard()
            if coop then highscore_index+=5 end
            highscore=dget(highscore_index)
            if points_total>highscore then
                dset(highscore_index,points_total)
            end
        end
        death_screen_calculated=true
    end

    local function draw()
        print("awards:", 111,126,7)
        print("",113,126,7)
        print("-distance bonus")
        print(" (+"..game_logic.get_distance()..")")
        if no_loot_bugs_killed then
            print("-no loot_bugs")
            print(" killed (+100)")
        end
        if no_cave_angels_killed then
            print("-no cave angels")
            print(" killed (+100)")
        end
        if no_eggs_killed then
            print("-you spared the")
            print(" scouts (+100)")
        end
        if at_title_screen then
            print("-died during the")
            print(" tutorial (+500)")
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
        print("game over!",108,105)
        print("score: "..points_total)
        print("highscore: "..highscore)
        local is_coop=coop and "coop" or ""
        print("at hazard "..game_logic.hazard()..is_coop,158,105)
        if points_total>highscore then
            print("new highscore!!!")
        end
    end

    local function report_killed_loot_bug()
        killed_loot_bugs.add(loot_bug_names[sample_one(1,#loot_bug_names)])
    end

    return {
        report_killed_loot_bug=report_killed_loot_bug,
        report_killed_cave_angel=function() no_cave_angels_killed=false end,
        report_killed_egg=function() no_eggs_killed=false end,
        calculate_death_screen=calculate_death_screen,
        draw=draw,
    }
end


