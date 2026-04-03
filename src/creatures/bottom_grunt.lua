

-- reduced grunt that takes hp at the bottom
function bottom_grunt(x,y)
    local frame=rnd(20)
    local up_down_frame=rnd(20)
    local up_down_cap=rnd(20)+40
    local x=x
    local y=y
    local y0=y
    local display_alt=false
    local alive=true
    local creature_damage=1
    local hitbox={x={1,8},y={1,8}}

    local function update()
        display_alt=frame>15
        -- animate grunts moving up and down
        y=y0+sgn(up_down_frame-up_down_cap/2)
        frame=frame%30+1
        up_down_frame=(up_down_frame+1)%up_down_cap
    end

    local function damage(damage_received,player)
        -- nothing ever happens here HAAA
    end

    local function draw()
        spr(1,x,y,1,1,display_alt,true)
    end

    local function x_f() return x end
    local function y_f() return y end
    local function is_alive() return alive end

    return {
        x=x_f,
        y=y_f,
        update=update,
        damage=damage,
        creature_damage=creature_damage,
        draw=draw,
        hitbox=hitbox,
        is_alive=is_alive,
    }
end


