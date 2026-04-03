

-- this file contains all hud elements
function new_hud()

    -- takes a percentage, as well as x and y position, and paints a prog bar
    local function draw_prog_bar(percentage,x,y)
        local green_pixels=flr(percentage*12)
        local color
        spr(63,x,y)
        spr(63,x+6,y)
        for i=1,12 do
            color=i>green_pixels and 8 or 11
            pset(x+i,y+1,color)
        end
    end

    -- draw up to three hearts representing player health
    local function draw_hearts(player,x)
        for i=1,3 do
            if i>player.health() then
                pal(8,6)
            end
            spr(31,x+8*(i-1),180)
            pal()
        end
    end

    local function draw(player)
        local x=player.number==1 and 105 or 202
        draw_hearts(player,x)
        spr(46,x,190)
        draw_prog_bar(player.ammo()/player.max_ammo,x+9,192)
        if player.max_fuel>0 then
            spr(47,x,200)
            draw_prog_bar(player.fuel()/player.max_fuel,x+9,202)
        end
        spr(62,x,210)
        print(player.points(),x+10,211,7)
    end

    return {
        draw=draw,
    }
end


