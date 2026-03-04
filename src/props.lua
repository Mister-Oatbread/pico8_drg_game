

-- this file takes care of the fancy props

function spawn_prop()
    local x=flr(rnd(120))+101
    local y=81
    local decision=rnd(100)
    local prop

    if decision<50 then
        prop=nectar_rind(x,y)
    elseif decision<80 then
        prop=orchey_shy(x,y)
    else
        prop=p0q(x,y)
    end
    add(props, prop)
end

function nectar_rind(x,y)
    local sprite
    local x = x
    local y = y
    local x_flip = coinflip()
    local y_flip = coinflip()
    function animate()
        y+=1
        local distance = (player.x_pos-x)^2 + (player.y_pos-y)^2
        if distance < 30^2 then
            sprite = 173
        else
            sprite = 172
        end
    end
    function draw()
        spr(sprite, x, y, 1, 1, x_flip, y_flip)
    end
    function x_coord() return x end
    function y_coord() return y end
    return {
        x_coord=x_coord,
        y_coord=y_coord,
        animate=animate,
        draw=draw,
    }
end

function orchey_shy(x, y)
    local sprite
    local x = x
    local y = y
    local x_flip = coinflip()
    local y_flip = coinflip()
    function animate()
        y+=1
        local distance = (player.x_pos-x)^2 + (player.y_pos-y)^2
        if distance < 225 then
            sprite = 190
        elseif distance < 900 then
            sprite = 189
        else
            sprite = 188
        end
    end
    function draw()
        spr(sprite, x, y, 1, 1, x_flip, y_flip)
    end
    function x_coord() return x end
    function y_coord() return y end
    return {
        x_coord=x_coord,
        y_coord=y_coord,
        animate=animate,
        draw=draw,
    }
end

function p0q(x, y)
    local sprite = 140
    local x = x
    local y = y
    local x_flip = coinflip()
    local y_flip = coinflip()
    local angle = 0
    local parts = {}
    local n = 30
    local initial_angle
    local r2d = 3.14/180
    for i=1,n do
        initial_angle = 360*i/n
        radius = ceil(rnd(12))
        add(parts,{radius=radius, angle=initial_angle})
    end
    function animate()
        y+=1
        angle = (angle+.25)%360
    end
    function draw()
        spr(sprite, x, y, 2, 2, x_flip, y_flip)
        local x_pos, y_pos
        for i=1,n do
            x_pos = ceil(parts[i].radius*cos((angle+parts[i].angle)*r2d))
            y_pos = ceil(parts[i].radius*sin((angle+parts[i].angle)*r2d))
            pset(x_pos+x+8, y_pos+y+8, 12)
        end
    end
    function x_coord() return x end
    function y_coord() return y end
    return {
        x_coord=x_coord,
        y_coord=y_coord,
        animate=animate,
        draw=draw,
    }
end

function initialize_props()
    props = {}
end

function update_props()
    if #props>0 then
        for prop in all(props) do
            prop.animate()
        end
        local i=1
        while #props>=i do
            if props[i].y_coord() >= 240 then
                deli(props, i)
            else
                i+=1
            end
        end
    end
    if rnd() < .02 then
        spawn_prop()
    end
end

function draw_props()
    if #props>0 then
        for prop in all(props) do
            prop.draw()
        end
    end
end


