

-- this file houses the entire logic for the game
function new_game_logic()

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
        update=update
    }
end


