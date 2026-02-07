

-- contains all sorts of miscellaneous things related to the game itself
function initialize_game()
    damaged_sprite_duration = 4;
    game_time = 0;
    game_status = "haz_screen";

    no_lootbugs_killed = true;
    no_cave_angels_killed = true;
    no_driller_drilled = true;

    difficulty = 2;
    if difficulty == 1 then
        obstacle_spawn_rate = .04;
        resource_spawn_rate = .05;

        creature_spawn_rate = .06;
        creature_spawn_ratios = {
            8, -- loot bug
            0, -- cave angel
            8, -- grunt
            0, -- slasher
            0, -- mactera
            1, -- praetorian
        };
        resource_spawn_ratios = {
            1, -- red_sugar
            0, -- nitra
            1, -- gold
        };
    elseif difficulty == 2 then
        obstacle_spawn_rate = .2;
        resource_spawn_rate = .01;

        creature_spawn_rate = .06;
        creature_spawn_ratios = {
            3, -- loot bug
            1, -- cave angel
            10, -- grunt
            2, -- slasher
            1, -- mactera
            1, -- praetorian
        };
        resource_spawn_ratios = {
            1, -- red_sugar
            1, -- nitra
            1, -- gold
        };
    end

    obstacle_spawn_ratios = {
        15, -- small
        1, -- big
    };
    creature_spawn_probs = get_cum_probs(creature_spawn_ratios);
    obstacle_spawn_probs = get_cum_probs(obstacle_spawn_ratios);
    resource_spawn_probs = get_cum_probs(resource_spawn_ratios);
end

function update_game()
    game_time += 1;
    if game_time%5==0 then player.points += 1 end;
    if difficulty == 1 then
        if game_time%800==799 then creature_spawn_rate+=.01 end;
        if game_time%850==849 then obstacle_spawn_rate+=.01 end;
        player.fuel = player.max_fuel;
        player.ammo = player.max_ammo;

    elseif difficulty == 2 then
        if game_time%200==199 then creature_spawn_rate+=.01 end;
        if game_time%250==249 then obstacle_spawn_rate+=.01 end;

        -- increase grunt spawn rate
        if game_time%600==599 then
            creature_spawn_ratios[3]+=1;
            creature_spawn_probs = get_cum_probs(creature_spawn_ratios);
        end
    end
    if player.health <= 0 then
        display_death_screen();
    end
end


-- this function takes a table of ratios for spawns and calculates
-- the corresponding cumulative probabilities for them.
function get_cum_probs(ratios)
    local sum = 0;
    local probs = {};
    for ratio in all(ratios) do
        add(probs, ratio);
        sum+=ratio;
    end

    -- calculate separate probabilities
    for i=1,#probs do
        probs[i] = probs[i]/sum;
    end

    -- calculate cumulative probability by summing over all probabilities that
    -- came before
    for i=2,#probs do
        probs[i] += probs[i-1];
    end

    return probs;
end


