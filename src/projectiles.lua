

-- this file contains the functionaly handling shots and hittig stuff
function new_projectiles()
    local bullets=new_entity_container()
    local spits=new_entity_container()

    local function update()
        for i=bullets.size(),1,-1 do
            bullets.get(i).y-=4
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
    local function fire_bullet(player)
        bullets.add({x=player.x(),y=(player.y())-8})
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
            spr(15,bullets.get(i).x, bullets.get(i).y)
        end
        for i=1,spits.size() do
            spits.get(i).draw()
        end
    end

    -- try to collide all bullets with all creatures
    local function check_bullet_collision()
        local no_creatures = #creatures
        local no_bullets = #bullets
        if no_creatures>0 and no_bullets>0 then
            local creature_box, bullet_box

            for i=no_creatures,1,-1 do
                creature_box = get_creature_hitbox(creatures[i])
                no_bullets = #bullets
                for j=no_bullets,1,-1 do
                    bullet_box = get_bullet_hitbox(bullets[j])

                    if are_colliding(bullet_box, creature_box) then
                        deli(bullets,j)
                        creatures[i].damage(10)
                    end
                end
            end
        end
    end

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

    return {
        update=update,
        draw=draw,
        fire_bullet=fire_bullet,
    }
end


