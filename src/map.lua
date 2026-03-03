

-- this file contains the needed files to generate the rolling background

function new_map()

    -- takes x,y coord and creates a random wall sprite with random x flip and
    -- according orientation for wall
    local function create_wall(x,y)
        local sprites={
            136,138,152,154,168,170,184,186,
            137,139,153,155,169,171,185,187,
        }
        local sprite=sprites[flr(rnd(#sprites))+1]
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
        local x=flr(rnd(128))+101
        local color
        if rnd(2)<1 then color=6 else color=2 end
        return {
            color=color,
            x=x,
            y=94,
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
            if rnd()<.2 then
                terrain.add(spawn_pebble())
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
                167,
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

    return {
        update=update,
        draw_wall=draw_wall,
        draw_super_wall=draw_super_wall,
        draw_terrain=draw_terrain,
    }
end


