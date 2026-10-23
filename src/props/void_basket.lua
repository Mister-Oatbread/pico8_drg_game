

function void_basket(x, y)
    local x=x
    local y=y
    local x_flip=coinflip()
    local y_flip=coinflip()
    local particles=new_entity_container()

    for i=1,sample_one(4,7) do
        particles.add({
            x_offset=sample_one(0,7),
            y_offset=sample_one(0,7),
            is_white=rnd()<.9,
        })
    end

    local function draw_particles()
        for i=1,particles.size() do
            local particle=particles.get(i)
            particle.x_offset, particle.y_offset=random_walk(
                particle.x_offset,
                particle.y_offset,
                .005
            )
            pset(x+particle.x_offset,y+particle.y_offset,particle.is_white and 7 or 14)
        end
    end

    return {
        x=function() return x end,
        y=function() return y end,
        update=function() y+=1 end,
        draw=function() spr(158,x,y,1,1,x_flip,y_flip) end,
        draw_particles=draw_particles,
    }
end


