

function p0q(x, y)
    local x=x
    local y=y
    local x_flip=coinflip()
    local y_flip=coinflip()
    local particles=new_entity_container()
    local n=20
    local radius,angle_offset,is_blue
    local angle=rnd()

    for i=1,n do
        angle_offset=i/n
        radius=sample_one(3,12)
        is_blue=rnd()<.9 and true or false
        particles.add({
            radius=radius,
            angle_offset=angle_offset,
            is_blue=is_blue,
        })
    end

    function draw_particles()
        local x_pos,y_pos
        for i=1,n do
            radius=particles.get(i).radius
            angle_offset=particles.get(i).angle_offset
            x_pos=ceil(radius*cos(angle+angle_offset))
            y_pos=ceil(radius*sin(angle+angle_offset))
            color=particles.get(i).is_blue and 12 or 7
            if rnd()>.99 then
                particles.get(i).is_blue=not particles.get(i).is_blue
            end
            pset(x_pos+x+8,y_pos+y+8,color)
        end
    end

    return {
        x=function() return x end,
        y=function() return y end,
        update=function() y+=1; angle=(angle+.003)%1 end,
        draw=function() spr(140,x,y,2,2,x_flip,y_flip) end,
        draw_particles=draw_particles,
    }
end

