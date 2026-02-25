

-- this file contains the functionaly handling shots and hittig stuff

function initialize_bullets()
    bullet_sprite = 15;
    bullets = {};

    spits = {};
end

function update_projectiles()
    local no_bullets = #bullets;

    for i=no_bullets,1,-1 do
        bullets[i].y_coord-=4;
        if bullets[i].y_coord<=91 then
            deli(bullets, i);
        end
    end

    local no_spits = #spits;
    for i=no_spits,1,-1 do
        spits[i].update();
        if spits[i].y_coord() >= 240 then
            deli(spits, i);
        end
    end
end

-- sends a bullet out from the current location of the player
function fire_bullet()
    add(bullets,{x_coord=player.x_pos, y_coord=player.y_pos-8});
end

-- fires a general spit from a creature, which gets constructed differently
-- depending on the type argument
function spit(type, x, y)
    local sprite, speed, size, hitbox, persists, damage;
    local x_flip = false;
    local y_flip = false;
    local frame = 0;

    if type == "praet_spit" then
        sprite = 9;
        speed = 1;
        size = 2;
        hitbox={x={4,12},y={1,16}};
        persists = true;
        damage = 1;
    elseif type == "praet_cloud" then
        sprite = 7;
        speed = 1;
        size = 2;
        hitbox={x={1,16},y={1,16}};
        persists = true;
        damage = 1;
    elseif type == "mactera_spit" then
        sprite = 31;
        speed = 2;
        size = 1;
        hitbox={x={4,4},y={3,7}};
        persists = false;
        damage = 1;
    end

    function update()
        -- compensate forward velocity when game is not gaming
        if game_status == "title_screen" then
            y -= 1;
        end

        y += speed;

        if type == "praet_spit" then
            x_flip = frame>30;
        elseif type == "praet_cloud" then
            x_flip = frame>30;
            y_flip = abs(frame-30)<15;
        end
        frame = (frame+1)%60;
    end

    function draw()
        spr(sprite, x, y, size, size, x_flip, y_flip);
    end

    function x_coord() return x end;
    function y_coord() return y end;

    return {
        update =update,
        draw = draw,
        x_coord = x_coord,
        y_coord = y_coord,
        persists = persists,
        damage = damage,
        hitbox = hitbox,
    };
end

-- adds a spit to the spits list
function add_spit(type, x_coord, y_coord)
    add(spits, spit(type, x_coord, y_coord));
end

function draw_projectiles()
    local no_bullets = #bullets;
    if no_bullets > 0 then
        for i=1,no_bullets do
            spr(bullet_sprite, bullets[i].x_coord, bullets[i].y_coord);
        end
    end

    local no_spits = #spits;
    if no_spits > 0 then
        for i=1,no_spits do
            spits[i].draw();
        end
    end
end

-- try to collide all bullets with all creatures
function check_bullet_collision()
    local no_creatures = #creatures;
    local no_bullets = #bullets;
    if no_creatures>0 and no_bullets>0 then
        local creature_box, bullet_box;

        for i=no_creatures,1,-1 do
            creature_box = get_creature_hitbox(creatures[i]);
            no_bullets = #bullets;
            for j=no_bullets,1,-1 do
                bullet_box = get_bullet_hitbox(bullets[j]);

                if are_colliding(bullet_box, creature_box) then
                    deli(bullets,j);
                    creatures[i].damage(10);
                end
            end
        end
    end
end

-- checks if one of the spits is currently colliding with the player
function check_spit_collision()
    local no_spits = #spits;
    local player_box = get_player_hitbox(player);
    local spit, spit_box;
    local colliding;

    if no_spits>0 then
        for i=no_spits,1,-1 do
            spit = spits[i];
            spit_box = get_spit_hitbox(spits[i]);

            colliding = are_colliding(player_box, spit_box);
            if (colliding and not player.has_invuln) then
                player.health -= spit.damage;
                player.is_hit = true;
                player.hit_since = 0;
                player.has_invuln = true;

                if not spit.persists then
                    deli(spits, i);
                end
            end
        end
    end
end


