

-- this file contains the functionaly handling shots and hittig stuff
function new_projectiles()
    local bullets=new_entity_container()
    local spits=new_entity_container()
    local bullet_damage=10

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
    end

    -- sends a bullet out from the current location of the player
    local function fire_bullet(number)
        local player=number==1 and player_1 or player_2
        bullets.add({x=player.x(),y=(player.y())-8,owner=player})
    end

    -- fires a general spit from a creature, which gets constructed differently
    -- depending on the type argument
    local function spit(spit_type, x, y)
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
            sprite=31
            speed=2
            size=1
            hitbox={x={4,4},y={3,7}}
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

        function x_f() return x end
        function y_f() return y end

        return {
            update=update,
            draw=draw,
            x=x_f,
            y=y_f,
            persists=persists,
            damage=damage,
            hitbox=hitbox,
        }
    end

    -- adds a spit to the spits list
    local function add_spit(spit_type,x,y)
        add(spits,spit(spit_type,x,y))
    end

    local function draw()
        for i=1,bullets.size() do
            spr(29,bullets.get(i).x, bullets.get(i).y)
        end
        for i=1,spits.size() do
            spits.get(i).draw()
        end
    end

    -- try to collide all bullets with all creatures

    -- checks if one of the spits is currently colliding with the player
    local function check_spit_collision()
        local no_spits = #spits
        local player_box = get_player_hitbox(player)
        local spit, spit_box
        local colliding

        if no_spits>0 then
            for i=no_spits,1,-1 do
                spit = spits[i]
                spit_box = get_spit_hitbox(spits[i])

                colliding = are_colliding(player_box, spit_box)
                if (colliding and not player.has_invuln) then
                    player.health -= spit.damage
                    player.is_hit = true
                    player.hit_since = 0
                    player.has_invuln = true

                    if not spit.persists then
                        deli(spits, i)
                    end
                end
            end
        end
    end

    -- takes in bullet and returns hitbox ready to be processed by are_colliding()
    function get_bullet_hitbox(bullet)
        return {
            x={bullet.x+6,bullet.x+6},
            y={bullet.y+5,bullet.y+15},
        };
    end

    -- takes spit and returns the corresponding hitbox
    function get_spit_hitbox(spit)
        local x1=spit.hitbox.x[1]+spit.x()-1;
        local x2=spit.hitbox.x[2]+spit.x()-1;
        local y1=spit.hitbox.y[1]+spit.y()-1;
        local y2=spit.hitbox.y[2]+spit.y()-1;
        return {x={x1,x2}, y={y1,y2}};
    end

    return {
        update=update,
        draw=draw,
        fire_bullet=fire_bullet,
        spits_list=spits,
        bullets_list=bullets,
        get_bullet_hitbox=get_bullet_hitbox,
        get_spit_hitbox=get_spit_hitbox,
        bullet_damage=bullet_damage,
    }
end


