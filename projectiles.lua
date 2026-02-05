

-- this file contains the functionaly handling shots and hittig stuff

function initialize_bullets()
    bullet_sprite = 15;
    bullets = {};
end

function update_bullets()
    local i=1;
    while (#bullets>=i) do
        bullets[i].y_coord-=2;
        if bullets[i].y_coord<=91 then
            deli(bullets, i);
        else
            i+=1;
        end
    end
end

-- sends a bullet out from the current location of the player
function fire_bullet()
    add(bullets,{x_coord=player.x_pos, y_coord=player.y_pos-8});
end

function draw_bullets()
    if #bullets > 0 then
        for bullet in all(bullets) do
            spr(bullet_sprite, bullet.x_coord, bullet.y_coord);
        end
    end

end

-- try to collide all bullets with all creatures
function check_bullet_collision()
    if #creatures>0 and #bullets>0 then
        local i=1;
        local j=1;
        local creature_box, bullet_box;
        while (#creatures>=i) do
            creature_box = get_creature_hitbox(creatures[i]);
            while (#bullets>=j) do
                bullet_box = get_bullet_hitbox(bullets[j]);

                if are_colliding(bullet_box, creature_box) then
                    deli(bullets,j);
                    creatures[i].damage(10)
                    break
                else
                    j+=1;
                end
            end
            j=1;
            i+=1;
        end
    end
end


