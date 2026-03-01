

-- this file houses the entire logic for the game
function new_game_logic()

    local function mine_resources()
        local resource,colliding,drilling,res_hitbox
        local hitbox_drills=player.get_drills_hitbox()
        for i=resources.get_resources().size(),1,-1 do
            resource=resources.get_resources().get(i)
            res_hitbox=resources.get_hitbox(resource)
            colliding=are_colliding(res_hitbox,hitbox_drills)
            drilling=player.is_drilling()
            if colliding and drilling then
                local res_type=resource.res_type
                if res_type=="red_sugar" then
                    player.give_health(1)
                elseif res_type=="nitra" then
                    player.give_ammo(.5)
                elseif res_type=="gold" then
                    points+=100
                end
                resources.get_resources().deletei(i)
                sfx(-1,3)
                sfx(38,3)
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


