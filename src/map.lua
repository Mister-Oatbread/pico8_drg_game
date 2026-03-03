

-- this file contains the needed files to generate the rolling background

function new_map()
    -- create walls needs to come first

    -- takes x,y coord and creates a random wall sprite with random x flip and
    -- according orientation for wall
    local function create_wall(x,y)
        -- choose one of the sprites
        local sprite=64+flr(rnd(4))+16*flr(rnd(4))
        return {
            sprite=sprite,
            x=x,
            y=y,
            x_flip=x>140,
            y_flip=rnd(2)<1,
            swap_gray=rnd(2)<1,
            swap_blue=rnd(2)<1,
        }
    end

    -- init -------------

    -- catalogue all sprites and infrastructure
    -- local map_sprites_base={128,128,128,128,128,144,160,176}
    local terrain=new_entity_container()
    local walls=new_entity_container()
    local super_walls=new_entity_container()
    local drilled_ground=new_entity_container()
    local obstacles=new_entity_container()
    local vines=new_entity_container()

    -- initialize walls with random sprite
    for x=102,220,118 do
        for y=91,228,8 do
            walls.add(create_wall(x,y))
        end
    end

    -- initialize super walls
    for i=98,230,130 do
        for j=91,228,8 do
            super_walls.add({x=i,y=j})
        end
    end

    local function spawn_pebble()
        local x=
        local color
        if rnd(2)<1 then color=6 else color=2 end
        return {
            color=color,
            x=flr(rnd(128))+101,
            y=94,
        }
    end

    local function spawn_vine()
        local sprites={76,78,108,110}
        local sprite=
        return {
            sprite=sprites[flr(rnd(#sprites))],
            x=flr(rnd(112))+101,
            y=81,
            x_flip=rnd(2)<1,
            y_flip=rnd(2)<1,
        }
    end

    local function spawn_drilled_ground(x,y)
        drilled_ground.add({x=x,y=y})
    end

    local function spawn_obstacle(x,y)
        local sprite,sprites,size
        if rnd(1)<obstacle_spawn_probs[1] then
            sprites={68,69,70,71,84,85,86,87,100,101,116,117}
            size=1
        else
            sprites={72,74,102,104,106}
            size=2
        end
        sprite=sprites[flr(rnd(#sprites))+1]
        return {
            sprite=sprite,
            x=x,
            y=y,
            size=size,
            x_flip=rnd(2)<1,
            y_flip=rnd(2)<1,
        }
    end

    -- slides the floor one frame to the bottom, and realigns the floor if needed
    local function update()
        local wall,terrain_piece
        if game_status=="playing" then
            for i=1,walls.size() do
                wall=walls.get(i)
                wall.y+=1
                if wall.y>=230 then
                    walls.replace(i,create_wall(wall.x,91))
                end
            end
            for i=terrain.size(),1,-1 do
                terrain_piece=terrain.get(i)
                terrain_piece.y+=1
                if terrain_piece.y>230 then
                    terrain.deletei(i)
                end
            end
            for i=drilled_ground.size(),1,-1 do
                drilled_ground.get(i).y+=1
                if drilled_ground.get(i).y>=230 then
                    drilled_ground.deletei(i)
                end
            end
            if rnd()<.8 then
                terrain.add(spawn_pebble())
            end
            for i=obstacles.size(),1,-1 do
                obstacles.get(i).y+=1
                if obstacles.get(i).y>=230 then
                    obstacles.deletei(i)
                end
            end
            if rnd()<obstacle_spawn_rate then
                obstacles.add(spawn_obstacle(flr(rnd(120))+101,81))
            end
            for i=vines.size(),1,-1 do
                vines.get(i).y+=1
                if vines.get(i).y>=230 then
                    vines.deletei(i)
                end
            end
            if rnd()<.05 then
                vines.add(spawn_vine())
            end
        end
    end

    local function draw_wall()
        local wall
        for i=1,walls.size() do
            wall=walls.get(i)
            if wall.swap_gray then pal(6,13) end
            if wall.swap_blue then pal(13,6) end
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

    local function draw_super_wall()
        for i=1,super_walls.size() do
            spr(
                61,
                super_walls.get(i).x,
                super_walls.get(i).y,
                1,1,false,false
            )
        end
    end

    local function draw_terrain()
        local terrain_piece
        for i=1,terrain.size() do
            terrain_piece=terrain.get(i)
            pset(terrain_piece.x,terrain_piece.y,terrain_piece.color)
        end
    end

    local function draw_drilled_ground()
        for i=1,drilled_ground.size() do
            spr(52,drilled_ground.get(i).x,drilled_ground.get(i).y)
        end
    end

    local function draw_obstacles()
        local obstacle
        for i=1,obstacles.size() do
            obstacle=obstacles.get(i)
            spr(
                obstacle.sprite,
                obstacle.x,
                obstacle.y,
                obstacle.size,
                obstacle.size,
                obstacle.x_flip,
                obstacle.y_flip
            )
        end
    end

    local function draw_vines()
        local vine
        for i=1,vines.size() do
            vine=vines.get(i)
            spr(vine.sprite,vine.x,vine.y,2,2,vine.x_flip,vine.y_flip)
        end
    end

    return {
        update=update,
        draw_wall=draw_wall,
        draw_super_wall=draw_super_wall,
        draw_terrain=draw_terrain,
        draw_drilled_ground=draw_drilled_ground,
        draw_obstacles=draw_obstacles,
        draw_vines=draw_vines,
        spawn_drilled_ground=spawn_drilled_ground,
    }
end


