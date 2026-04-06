

-- this file houses the entire logic for the game
function new_game_logic()
    local obstacle_spawn_rate=.2
    local obstacle_growth_rate=.03
    local obstacle_variety=2
    local obstacle_ratios={
        {15,"small"},
        {1,"big"},
    }

    local resource_spawn_rate=.01
    local resource_growth_rate=0
    local resource_variety=3
    local resource_ratios={
        {1,"gold"},
        {1,"nitra"},
        {1,"red_sugar"},
    }

    local creature_spawn_rate=.06
    local creature_growth_rate=.02
    local creature_variety=7
    local creature_ratios={
        {2,loot_bug},
        {.01,egg},
        {1,cave_angel},
        {10,grunt},
        {1,praetorian},
        {2,slasher},
        {1,mactera},
        {.5,menace},
        {1,oppressor},
    }

    local timer=0
    local creature_spawn_params
    local obstacle_spawn_params
    local resource_spawn_params
    local hazard=1

    local function set_difficulty(difficulty)
        if at_title_screen then
            if difficulty==1 then
                obstacle_spawn_rate=.08
                resource_spawn_rate=.03
                creature_spawn_rate=.04
                obstacle_growth_rate=.02
                creature_growth_rate=.01
                creature_variety=4
            elseif difficulty==2 then
                creature_spawn_rate=.04
                creature_growth_rate=.01
                creature_variety=5
            elseif difficulty==3 then
                creature_variety=7
            -- elseif difficulty==4 then
            elseif difficulty==5 then
                resource_variety=2
            end
            creature_spawn_params=generate_spawn_params(
                creature_ratios,creature_variety
            )
            obstacle_spawn_params=generate_spawn_params(
                obstacle_ratios,obstacle_variety
            )
            resource_spawn_params=generate_spawn_params(
                resource_ratios,resource_variety
            )
            at_title_screen=false
            playing=true
            hazard=difficulty
            music(-1,0,0)
            music(1,0,0)
        end
    end

    local function mine_resources(player)
        local resource,res_hitbox,mining_hitbox
        if player.is_drilling() or player.is_mining() then
            mining_hitbox=player.get_mining_hitbox()
            for i=resources.get_resources.size(),1,-1 do
                resource=resources.get_resources.get(i)
                res_hitbox=resources.get_hitbox(resource)
                if are_colliding(res_hitbox,mining_hitbox) then
                    local res_type=resource.res_type
                    if res_type=="red_sugar" then
                        player.give_health(1)
                        resources.get_resources.deletei(i)
                    elseif res_type=="nitra" then
                        player.give_ammo(.5)
                        resources.get_resources.deletei(i)
                    elseif res_type=="gold" then
                        player.give_points(100)
                        resources.get_resources.deletei(i)
                    elseif res_type=="class" then
                        player.change_role(resource.value)
                    elseif res_type=="number" then
                        game_logic.set_difficulty(resource.value)
                    end
                    sfx(38,3)
                end
            end
        end
    end

    local function damage_creatures()
        local creature_box,bullet_box,melee_box
        local creatures_list=creatures.creatures_list
        local bullets=projectiles.bullets_list
        local creature,bullet,player_damage

        -- get drills hitbox if player is drilling, else assign meaningless
        -- hitbox that can never collide

        for i=1,creatures_list.size() do
            creature=creatures_list.get(i)
            creature_box=get_hitbox(creature)
            for j=bullets.size(),1,-1 do
                bullet=bullets.get(j)
                bullet_box=projectiles.get_bullet_hitbox(bullet)
                if are_colliding(bullet_box, creature_box) then
                    creature.damage(bullet.damage,bullet.owner)
                    if not bullet.piercing then
                        bullets.deletei(j)
                    end
                end
            end
            -- TODO: recalculating this all the time is not ideal,
            -- find better solution
            for player in all(players) do
                if player.is_drilling() then
                    melee_box=player.get_damaging_hitbox()
                    player_damage=player.drills_damage
                elseif player.is_mining() then
                    melee_box=player.get_damaging_hitbox()
                    player_damage=player.mining_damage
                else
                    melee_box={x={3,4},y={3,4}}
                    player_damage=0
                end
                if are_colliding(creature_box,melee_box) then
                    creature.damage(player_damage,player)
                end
            end
        end
    end

    local function damage_player(player)
        local player_box,spit_box,creature_box
        local spit,creature,spits
        player_box=player.get_hitbox()
        spits=projectiles.spits_list
        for i=spits.size(),1,-1 do
            spit=spits.get(i)
            spit_box=projectiles.get_spit_hitbox(spit)
            if are_colliding(player_box,spit_box) then
                player.damage(spit.damage)
                if not spit.persists then
                    spits.deletei(i)
                end
            end
        end
        for i=creatures.creatures_list.size(),1,-1 do
            creature=creatures.creatures_list.get(i)
            creature_box=creatures.get_hitbox(creature)
            if are_colliding(player_box,creature_box) then
                if creature.creature_damage>0 then
                    player.damage(creature.creature_damage)
                end
            end
        end
    end

    local function update()
        for player in all(players) do
            mine_resources(player)
            damage_player(player)
        end
        damage_creatures()

        if hazard==1 and timer%128==0 then
            for player in all(players) do
                player.give_ammo(.1)
            end
        end
        if playing then
            if rnd()<creature_spawn_rate then
                creatures.spawn()
            end
            if rnd()<obstacle_spawn_rate then
                map.spawn_obstacle(sample_one(100,220),81)
            end
            if rnd()<resource_spawn_rate then
                resources.spawn(sample_one(102,220),81)
            end
            timer+=1
            if timer%640==0 then
                creature_spawn_rate+=creature_growth_rate
                obstacle_spawn_rate+=obstacle_growth_rate
                resource_spawn_rate+=resource_growth_rate
            end
        end
        for player in all(players) do
            if player.health()<=0 then
                playing=false
                at_death_screen=true
            end
        end
    end

    return {
        update=update,
        set_difficulty=set_difficulty,
        get_distance=function() return flr(timer/5) end,
        obstacle_spawn_params=function() return obstacle_spawn_params end,
        resource_spawn_params=function() return resource_spawn_params end,
        creature_spawn_params=function() return creature_spawn_params end,
        hazard=function() return hazard end,
    }
end


