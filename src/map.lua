

function add_wall(x,y)
    return {
        sprite=sample_one(64,79),
        x=x,
        y=y,
        x_flip=x>140,
        y_flip=coinflip(),
        color_profile=sample_one(1,3),
    }
end

function add_drilled_ground(sprite,x,y)
    drilled_ground.add({sprite=sprite,x=x,y=y})
end

function spawn_obstacle(sprite, x, y, size, color_profile, x_flip, y_flip)
    -- check of size has ben set, else pick one at random
    size = size or pick_spawn(obstacle_spawn_params)

    if sprite==nil then
        if size==1 then
            sprite=sample_one(80,90)
        else
            sprite=96+2*sample_one(1,5)
        end
    end

    if x_flip==nil then x_flip=coinflip() end
    if y_flip==nil then y_flip=coinflip() end

    -- pass on attributes, or if none have been assigned, pick at random
    obstacles.add({
        sprite=sprite,
        x=x or sample_one(101,220),
        y=y or 81,
        size=size,
        x_flip=x_flip,
        y_flip=x_flip,
        color_profile=color_profile or sample_one(1,3),
    })
end

-- slides the floor one frame to the bottom, and realigns the floor if needed
function update_map()
    local wall,terrain_piece,squishy_piece,squishy_box
    local player_boxes = {}

    for player in all(players) do
        add(player_boxes, player.get_hitbox())
    end

    if playing then
        for i=1,walls.size() do
            wall=walls.get(i)
            wall.y+=1
            if wall.y>=230 then
                walls.replace(i,add_wall(wall.x,91))
            end
        end

        for i=terrain.size(),1,-1 do
            terrain_piece=terrain.get(i)
            terrain_piece.y+=1
            if terrain_piece.y>230 then
                terrain.deletei(i)
            end
        end

        for i=squishy_stuff.size(),1,-1 do
            squishy_piece=squishy_stuff.get(i)
            squishy_piece.y+=1
            if squishy_piece.y>230 then
                squishy_stuff.deletei(i)
            end
            squishy_box = get_squishy_hitbox(squishy_piece)
            for player_box in all(player_boxes) do
                if are_colliding(player_box, squishy_box) then
                    sfx(56,3)
                    squishy_stuff.deletei(i)
                end
            end
        end

        -- remove_bottom_entities(drilled_ground,y)
        for i=drilled_ground.size(),1,-1 do
            drilled_ground.get(i).y+=1
            if drilled_ground.get(i).y>=230 then
                drilled_ground.deletei(i)
            end
        end

        terrain.add({
            x=sample_one(101,227),
            y=94,
            color=coinflip() and 6 or 2,
        })

        for i=obstacles.size(),1,-1 do
            obstacles.get(i).y+=1
            if obstacles.get(i).y>=230 then
                obstacles.deletei(i)
            end
        end

        if rnd()<.01 then
            squishy_ratios={
                {1,"bloopy_fruit"},
                {1,"oripricot"},
                {1,"pulsa_stickpod"},
            }
            squishy_spawn_params=generate_spawn_params(squishy_ratios,#squishy_ratios)
            local choice = pick_spawn(squishy_spawn_params)

            local x_anchor=sample_one(100,200)
            local cluster_positions = get_cluster_positions({x_anchor, x_anchor+20},{20,30})
            for i=1,cluster_positions.size() do
                local cluster_pos = cluster_positions.get(i)
                squishy_stuff.add(spawn_squishy_thing(cluster_pos[1], cluster_pos[2],choice))
            end
        end
    end
end

function draw_super_wall()
    for i=1,super_walls.size() do
        spr(61, super_walls.get(i).x, super_walls.get(i).y, 1, 1, false, false)
    end
end

function draw_base_map()
    local terrain_piece, obstacle

    for i=1,terrain.size() do
        terrain_piece=terrain.get(i)
        pset(terrain_piece.x,terrain_piece.y,terrain_piece.color)
    end

    for i=1,obstacles.size() do
        obstacle=obstacles.get(i)
        swap_colors(obstacle.color_profile)
        spr(
            obstacle.sprite,
            obstacle.x,
            obstacle.y,
            obstacle.size,
            obstacle.size,
            obstacle.x_flip,
            obstacle.y_flip
        )
        pal()
    end
end

function draw_walls()
    local wall
    for i=1,walls.size() do
        wall=walls.get(i)
        swap_colors(wall.color_profile)
        spr(
            wall.sprite,
            wall.x,
            wall.y,
            1,1,
            wall.x_flip,
            wall.y_flip
        )
        pal()
    end
end

function draw_drilled_ground()
    local ground_piece
    for i=1,drilled_ground.size() do
        ground_piece=drilled_ground.get(i)
        spr(ground_piece.sprite,ground_piece.x,ground_piece.y)
    end
end


