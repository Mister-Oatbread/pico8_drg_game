

-- reduced grunt that takes hp at the bottom
function bottom_grunt(x,y)
    local frame=flr(rnd(20))
    local up_down_frame=flr(rnd(20))
    local up_down_cap=sample_one(20,40)
    local x=x
    local y=y
    local y0=y
    local display_alt=false
    local creature_damage=1
    local hitbox={x={1,8},y={1,8}}

    local function update()
        display_alt=frame>15

        -- animate grunts moving up and down
        y=y0+sgn(up_down_frame-up_down_cap/2)
        frame=frame%30+1
        up_down_frame=(up_down_frame+1)%up_down_cap
    end

    return {
        update=update,
        damage=function(damage_received, player) end,
        creature_damage=creature_damage,
        draw=function() spr(1,x,y,1,1,display_alt,true) end,
        hitbox=hitbox,
        x=function() return x end,
        y=function() return y end,
        is_alive=function() return true end,
    }
end


