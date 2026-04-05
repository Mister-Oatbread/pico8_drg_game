

function p0q(x, y)
    local x=x
    local y=y
    local x_flip=coinflip()
    local y_flip=coinflip()
    local particles=new_entity_container()
    local n=30
    local angle_offset
    local angle=rnd()

    for i=1,n do
        angle_offset=360*i/n
        radius=sample_one(3,12)
        particles.add({radius=radius,angle_offset=angle_offset})
    end

    -- function update()
    --     y+=1
    --     angle = (angle+.01)%1
    -- end

    function draw_particles()
        local x_pos, y_pos, radius, offset
        for i=1,n do
            radius=particles.get(i).radius
            offset=particles.get(i).offset
            x_pos=ceil(radius*cos(angle+offset))
            y_pos=ceil(radius*sin(angle+offset))
            pset(x_pos+x+8, y_pos+y+8, 12)
        end
    end

    return {
        x=function() return x end,
        y=function() return y end,
        update=function() y+=1; angle=(angle+.01)%1 end,
        draw=function() spr(140,x,y,2,2,x_flip,y_flip) end,
        draw_particles=function() end,
    }
end

