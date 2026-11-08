

-- determines certain parameters for the death screen
function calculate_death_screen()
    if not death_screen_calculated then
        no_loot_bugs_killed=killed_loot_bugs.size()==0
        for player in all(players) do
            player.reposition(120+8*player.number()-1,193)
            points_total+=player.points()
        end

        points_total+=get_distance()
        if no_loot_bugs_killed then points_total+=100 end
        if no_cave_angels_killed then points_total+=100 end
        if no_eggs_killed then points_total+=100 end
        if at_title_screen then points_total+=500 end
        points_total=flr(points_total)

        local highscore_index=hazard
        if coop then highscore_index+=5 end
        highscore=dget(highscore_index)
        if points_total>highscore then
            dset(highscore_index,points_total)
        end
    end
    death_screen_calculated=true
end

function draw_death_screen()
    print("awards:", 111,126,7)
    print("",113,126,7)
    print("-distance bonus")
    print(" (+"..get_distance()..")")
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
    print("game over!",108,105,15)
    print("score: "..points_total)
    print("highscore: "..highscore)
    local is_coop=coop and "coop" or ""
    print("at hazard "..hazard..is_coop,158,105)
    if points_total>highscore then
        print("new highscore!!!")
    end
end


