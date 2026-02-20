

-- this file contains the functionaly handling shots and hittig stuff

function initialize_bullets()
    bullet_sprite = 15;
    bullets = {};
end

function update_bullets()
    local no_bullets = #bullets;

    for i=no_bullets,1,-1 do
        bullets[i].y_coord-=2;
        if bullets[i].y_coord<=91 then
            deli(bullets, i);
        end
    end
end

-- sends a bullet out from the current location of the player
function fire_bullet()
    add(bullets,{x_coord=player.x_pos, y_coord=player.y_pos-8});
end

function draw_bullets()
    local no_bullets = #bullets;
    if no_bullets > 0 then
        for i=1,no_bullets do
            spr(bullet_sprite, bullets[i].x_coord, bullets[i].y_coord);
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
                    creatures[i].damage(10)
                end
            end
        end
    end
end


