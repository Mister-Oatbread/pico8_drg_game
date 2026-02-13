

-- this file takes care of the fancy props

function spawn_prop()
    local x_coord = flr(rnd(120))+101;
    local y_coord = 81;
    prop = nectar_rind(x_coord, y_coord);
    add(props, prop);
end

function nectar_rind(x,y)
    local sprite = prop_sprites.nectar_rind.open;
    local x = x;
    local y = y;
    local x_flip = rnd(2)<1;
    local y_flip = rnd(2)<1;
    function animate()
        y+=1;
        local distance = (player.x_pos-x)^2 + (player.y_pos-y)^2;
        if distance < 30^2 then
            sprite = prop_sprites.nectar_rind.closed;
        else
            sprite = prop_sprites.nectar_rind.open;
        end
    end
    function draw()
        spr(sprite, x, y, 1, 1, x_flip, y_flip);
    end
    function x_coord() return x end;
    function y_coord() return y end;
    return {
        x_coord=x_coord,
        y_coord=y_coord,
        animate=animate,
        draw=draw,
    };
end

function initialize_props()
    props = {};
    prop_sprites = {
        nectar_rind = {open=172, closed=158},
    };
end

function update_props()
    if #props>0 then
        for prop in all(props) do
            prop.animate();
        end
        local i=1;
        while #props>=i do
            if props[i].y_coord() >= 240 then
                deli(props, i);
            else
                i+=1;
            end
        end
    end
    if rnd() < .02 then
        spawn_prop();
    end
end

function draw_props()
    if #props>0 then
        for prop in all(props) do
            prop.draw();
        end
    end
end


