

-- this file contains the functionaly handling shots and hittig stuff
function new_projectiles()
    local bullets=new_entity_container()
    local spits=new_entity_container()
    local menace_spits=new_entity_container()

    -- sends a bullet out from the current location of the player
    local function fire_bullet(number)
        local player=number==1 and players[1] or players[2]
        bullets.add({
            x=player.x(),
            y=(player.y())-8,
            owner=player,
            damage=player.get_role()=="gunner" and 5 or 10,
            piercing=player.get_role()=="gunner",
            --
            -- TODO: find out why both are currently piercing if I set this
            -- up properly
            -- piercing=player.get_role()=="driller" and false or true,
        })
    end

    -- fires a general spit from a creature, which gets constructed differently
    -- depending on the type argument
    local function new_spit(spit_type,x,y)
        local sprite,speed,size,hitbox,persists,damage
        local x_flip,y_flip=false,false
        local frame=0

        if spit_type=="praet_spit" then
            sprite=9
            speed=1
            size=2
            hitbox={x={4,12},y={1,16}}
            persists=true
            damage=1
        elseif spit_type=="praet_cloud" then
            sprite=7
            speed=1
            size=2
            hitbox={x={1,16},y={1,16}}
            persists=true
            damage=1
        elseif spit_type=="mactera_spit" then
            sprite=28
            speed=2
            size=1
            hitbox={x={5,5},y={6,8}}
            persists=false
            damage=1
        end

        local function update()
            -- compensate forward velocity when game is not gaming
            if game_status=="title_screen" then
                y-=1
            end
            y+=speed

            if type=="praet_spit" then
                x_flip=frame>30
            elseif type=="praet_cloud" then
                x_flip=frame>30
                y_flip=abs(frame-30)<15
            end
            frame=(frame+1)%60
        end

        local function draw()
            spr(sprite,x,y,size,size,x_flip,y_flip)
        end

        return {
            update=update,
            draw=draw,
            x=function() return x end,
            y=function() return y end,
            persists=persists,
            damage=damage,
            hitbox=hitbox,
        }
    end

    -- adds a spit to the spits list
    local function spit_spit(spit_type,x,y)
        spits.add(new_spit(spit_type,x,y))
    end

    local function add_menace_spit(x,y,x_vel,y_vel)
        menace_spits.add({x=x,y=y,x_vel=x_vel,y_vel=y_vel})
    end

    local function update()
        for i=bullets.size(),1,-1 do
            bullets.get(i).y-=6
            if bullets.get(i).y<=91 then
                bullets.deletei(i)
            end
        end
        for i=spits.size(),1,-1 do
            spits.get(i).update()
            if spits.get(i).y()>=240 then
                spits.deletei(i)
            end
        end
        local spit
        for i=menace_spits.size(),1,-1 do
            spit=menace_spits.get(i)
            spit.x+=spit.x_vel
            spit.y+=spit.y_vel
            if spit.x<99 or spit.x>230 or spit.y<99 or spit.y>230 then
                menace_spits.deletei(i)
            end
        end
    end

    local function draw()
        for i=1,bullets.size() do
            spr(29,bullets.get(i).x, bullets.get(i).y)
        end
        for i=1,spits.size() do
            spits.get(i).draw()
        end
        local x,y
        for i=1,menace_spits.size() do
            x=flr(menace_spits.get(i).x)
            y=flr(menace_spits.get(i).y)
            pset(x,y,12)
        end
    end

    -- takes in bullet and returns hitbox ready to be processed by are_colliding()
    local function get_bullet_hitbox(bullet)
        return {
            x={bullet.x+6,bullet.x+6},
            y={bullet.y+5,bullet.y+15},
        }
    end

    -- takes spit and returns the corresponding hitbox
    local function get_spit_hitbox(spit)
        local x1=spit.hitbox.x[1]+spit.x()-1
        local x2=spit.hitbox.x[2]+spit.x()-1
        local y1=spit.hitbox.y[1]+spit.y()-1
        local y2=spit.hitbox.y[2]+spit.y()-1
        return {x={x1,x2}, y={y1,y2}}
    end

    local function get_menace_spit_hitbox(spit)
        return {x={flr(spit.x),flr(spit.x)},y={flr(spit.y),flr(spit.y)}}
    end

    return {
        update=update,
        draw=draw,
        fire_bullet=fire_bullet,
        spit_spit=spit_spit,
        add_menace_spit=add_menace_spit,
        spits_list=spits,
        bullets_list=bullets,
        get_bullet_hitbox=get_bullet_hitbox,
        get_spit_hitbox=get_spit_hitbox,
        get_menace_spit_hitbox=get_menace_spit_hitbox,
    }
end


