

-- this file houses the entire logic for the game
function new_game_logic()
    local obstacle_ratios,resource_ratios,creature_ratios

    local function set_difficulty(difficulty)
        creature_ratios={
            {2,loot_bug},
            {1,cave_angel},
            {10,grunt},
            {1,praetorian},
            {2,slasher},
            {1,mactera},
            {1,menace},
            {1,oppressor},
        }
        resource_ratios={
            {1,"gold"},
            {1,"nitra"},
            {1,"red_sugar"},
        }
        obstacle_ratios={
            {15,"small"},
            {1,"big"},
        }
        creature_variety=8
        resource_variety=3
        obstacle_variety=2
        if difficulty==1 then
            obstacle_spawn_rate=.08
            resource_spawn_rate=.05
            creature_spawn_rate=.04
            creature_variety=4
            resource_variety=1
        elseif difficulty==2 then
            obstacle_spawn_rate=.2
            resource_spawn_rate=.01
            creature_spawn_rate=.04
            creatre_variety=5
        elseif difficulty==3 then
            obstacle_spawn_rate=.2
            resource_spawn_rate=.01
            creature_spawn_rate=.06
        elseif difficulty==4 then
            obstacle_spawn_rate=.2
            resource_spawn_rate=.01
            creature_spawn_rate=.06
        elseif difficulty==5 then
            obstacle_spawn_rate=.2
            resource_spawn_rate=.01
            creature_spawn_rate=.06
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
    end

    local function mine_resources()
        local resource,res_hitbox,player,mining_hitbox
        for p=1,#players do
            player=players[p]
            if player.is_drilling() or player.is_mining() then
                mining_hitbox=player.get_mining_hitbox()
                for i=resources.get_resources().size(),1,-1 do
                    resource=resources.get_resources().get(i)
                    res_hitbox=resources.get_hitbox(resource)
                    if are_colliding(res_hitbox,mining_hitbox) then
                        local res_type=resource.res_type
                        if res_type=="red_sugar" then
                            player.give_health(1)
                        elseif res_type=="nitra" then
                            player.give_ammo(.5)
                        elseif res_type=="gold" then
                            player.give_points(100)
                        end
                        resources.get_resources().deletei(i)
                        sfx(-1,3)
                        sfx(38,3)
                    end
                end
            end
        end
    end

    local function damage_creatures()
        local player_box=player_1.get_hitbox()
        local creature_box,bullet_box,drills_box
        local creatures_list=creatures.creatures_list
        local bullets=projectiles.bullets_list
        local creature,bullet

        -- get drills hitbox if player is drilling, else assign meaningless
        -- hitbox that can never collide
        if player_1.is_drilling() then
            drills_box=player_1.get_damaging_hitbox()
        else
            drills_box={x={3,4},y={3,4}}
        end

        for i=1,creatures_list.size() do
            creature=creatures_list.get(i)
            creature_box=get_hitbox(creature)
            for j=bullets.size(),1,-1 do
                bullet=bullets.get(j)
                bullet_box=projectiles.get_bullet_hitbox(bullet)
                if are_colliding(bullet_box, creature_box) then
                    creature.damage(bullet.damage,player_1)
                    if not bullet.piercing then
                        bullets.deletei(j)
                    end
                end
            end
            if are_colliding(creature_box,drills_box) then
                creature.damage(player_1.drills_damage,player_1)
            end
        end

    --     local function check_bullet_collision()
    --         local no_creatures = #creatures
    --         local no_bullets = #bullets
    --         if no_creatures>0 and no_bullets>0 then
    --             local creature_box, bullet_box
    --
    --             for i=no_creatures,1,-1 do
    --                 creature_box = get_creature_hitbox(creatures[i])
    --                 no_bullets = #bullets
    --                 for j=no_bullets,1,-1 do
    --                     bullet_box = get_bullet_hitbox(bullets[j])
    --
    --                     if are_colliding(bullet_box, creature_box) then
    --                         deli(bullets,j)
    --                         creatures[i].damage(10)
    --                     end
    --                 end
    --             end
    --         end
    --     end
    end

    local function update()
        mine_resources()

        damage_creatures()

        if rnd()<creature_spawn_rate then
            creatures.spawn()
        end
        if rnd()<obstacle_spawn_rate then
            map.spawn_obstacle(sample_one(100,120),81)
        end
        if rnd()<resource_spawn_rate then
            resources.spawn(sample_one(102,118),81)
        end
    end

    local function obstacle_spawn_params_f() return obstacle_spawn_params end
    local function resource_spawn_params_f() return resource_spawn_params end
    local function creature_spawn_params_f() return creature_spawn_params end

    return {
        update=update,
        set_difficulty=set_difficulty,
        obstacle_spawn_params=obstacle_spawn_params_f,
        resource_spawn_params=resource_spawn_params_f,
        creature_spawn_params=creature_spawn_params_f,
    }
end


