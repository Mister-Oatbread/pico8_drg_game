

-- this file contains the logic for the player character

-- initialize player
function new_player(number,role)
    local function change_role(new_role)
        role=new_role
        max_ammo=role=="gunner" and 100 or 25
        ammo=max_ammo
        max_fuel=role=="driller" and 250 or 0
        fuel=max_fuel
        shot_delay=role=="gunner" and 1 or 3
        dset(10+number,role_numbers[role])
    end

    local x=140+8*number
    local y=205
    local frame=0
    local role_numbers={driller=1,gunner=2,engineer=3}
    local number=number
    local role=role

    local is_walking=false
    local is_moving_right=false
    local is_moving_left=false
    local is_sprinting=false
    local is_standing=true
    local is_crawling=false

    local is_mining=false
    local is_drilling=false
    local is_shooting=false
    local mining_since=30
    local mining_delay=3
    local shot_since=30
    local shot_delay=role=="gunner" and 1 or 3
    local mining_damage=10
    local drills_damage=4

    local max_ammo,max_fuel,fuel,ammo
    change_role(role)
    local max_health=3
    local health=max_health
    local hit_since=60

    local collision_points_left={}
    local collision_points_right={}
    local collision_points_top={}
    local has_collision_left=false
    local has_collision_right=false
    local has_collision_top=false

    for i=1,6 do
        add(collision_points_left,{x=0,y=0})
        add(collision_points_right,{x=0,y=0})
        add(collision_points_top,{x=0,y=0})
    end

    -- check what player is currently doing
    local function fetch_inputs()
        local p=number-1

        is_moving_left=btn(0,p)
        is_moving_right=btn(1,p)
        is_standing=(
            playing and btn(3,p)
        ) or (
            at_title_screen and not (btn(3,p) or btn(2,p))
        )
        is_sprinting=btn(2,p) and playing
        is_drilling=btn(4,p) and not btn(5,p) and fuel>0
        is_mining=btn(4,p) and not btn(5,p) and fuel=0
        is_shooting=btn(5,p) and not btn(4,p)
        is_crawling=role=="gunner" and is_shooting
    end

    local function update_player_collision_points()
        -- left flank
        for i=1,6 do
            collision_points_left[i].x=x
            collision_points_left[i].y=y+i
        end
        -- right flank
        for i=1,6 do
            collision_points_right[i].x=x+7
            collision_points_right[i].y=y+i
        end
        -- top flank
        for i=1,6 do
            collision_points_top[i].x=x+i
            collision_points_top[i].y=y-1
        end
    end

    local function find_terrain_collision()
        local function check_all(points)
            local color
            for i=1,#points do
                color=pget(points[i].x, points[i].y)
                if color==5 or color==13 then
                    return true
                end
            end
            return false
        end
        has_collision_left=check_all(collision_points_left)
        has_collision_right=check_all(collision_points_right)
        has_collision_top=check_all(collision_points_top)
    end

    -- places mined ground under the player, even though
    -- "drilled_ground" is called
    local function mine()
        if mining_since>mining_delay then
            map.add_drilled_ground(53,x,y-2)
            sfx(-1,number)
            sfx(31,number)
            mining_since=0
        end
    end

    local function shoot()
        if shot_since>shot_delay then
            if ammo>0 then
                projectiles.fire_bullet(number)
                ammo-=1
                if role=="gunner" and not playing_sound_of.gun then
                    sfx(36,number)
                    playing_sound_of.gun=true
                elseif role=="driller" or role=="engineer" then
                    sfx(34,number)
                end
            else
                sfx(35,number)
            end
            shot_since=0
        end
    end

    local function drill()
        if fuel>0 then
            map.add_drilled_ground(52,x,y-2)
            fuel-=1
            if not playing_sound_of.drill then
                sfx(-1,number)
                sfx(30,number)
                playing_sound_of.drill=true
            end
        end
    end

    -- give ammo based on max capacity and cap it
    local function give_resources(percentage)
        ammo=min(ammo+max_ammo*percentage,max_ammo)
        fuel=min(fuel+max_fuel*percentage,max_fuel)
    end

    local function damage_player(amount)
        if hit_since>30 then
            health-=amount
            sfx(32,number)
            hit_since=0
        end
    end

    local function update()
        fetch_inputs()
        update_player_collision_points()
        find_terrain_collision()

        if is_drilling then drill() end
        if is_shooting then shoot() end
        if is_mining then mine() end
        shot_since+=1
        mining_since+=1
    end

    local function draw()
    end

    return {
        update=update,
        draw=draw,

        change_role=change_role,
        give_resources=give_resources,
        damage_player=damage_player,

        -- getters
        x=function() return x end,
        y=function() return y end,
        is_drilling=function() return is.drilling end,
        is_shooting=function() return is.shooting end,
        is_mining=function() return mining_since<2 end,
        get_role=function() return role end,
        is_rns=function() return is.rns end,
        health=function() return health end,
        number=function() return number end,
        ammo=function() return ammo end,
        fuel=function() return fuel end,
        points=function() return points end,
        max_ammo=function() return max_ammo end,
        max_fuel=function() return max_fuel end,
        drills_damage=drills_damage,
        mining_damage=mining_damage,
    }
end


