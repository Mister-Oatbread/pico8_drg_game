

-- this file houses the entire logic for the game
function new_game_logic()
    local obstacle_ratios,resource_ratios,creature_ratios

    local function set_difficulty(difficulty)
        creature_ratios={
            2, -- loot bug
            1, -- cave angel
            10, -- grunt
            1, -- praetorian
            2, -- slasher
            1, -- mactera
        }
        resource_ratios={
            1, -- gold
            1, -- nitra
            1, -- red_sugar
        }
        obstacle_ratios={
            15, -- small
            1, -- big
        }
        creature_variety=6
        resource_variety=3
        obstacle_variety=2
        if difficulty==1 then
            obstacle_spawn_rate=.04
            resource_spawn_rate=.05
            creature_spawn_rate=.06
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
        get_cum_sum(creature_ratios,creature_variety)
        get_cum_sum(obstacle_ratios,obstacle_variety)
        get_cum_sum(resource_ratios,resource_variety)
    end

    local function mine_resources()
        local resource,colliding,drilling_1,drilling_2,res_hitbox
        local hitbox_drills_1=player_1.get_drills_hitbox()
        local hitbox_drills_2=player_2.get_drills_hitbox()
        drilling_1=player_1.is_drilling()
        drilling_2=player_2.is_drilling()
        if drilling_1 or drilling_2 then
            for i=resources.get_resources().size(),1,-1 do
                resource=resources.get_resources().get(i)
                res_hitbox=resources.get_hitbox(resource)
                colliding_1=are_colliding(res_hitbox,hitbox_drills)
                if colliding then
                    local res_type=resource.res_type
                    if res_type=="red_sugar" then
                        player_1.give_health(1)
                    elseif res_type=="nitra" then
                        player_1.give_ammo(.5)
                    elseif res_type=="gold" then
                        points+=100
                    end
                    resources.get_resources().deletei(i)
                    sfx(-1,3)
                    sfx(38,3)
                end
            end
        end
    end

    local function update()
        mine_resources()
    end

    return {
        update=update,
        set_difficulty=set_difficulty,
    }
end


