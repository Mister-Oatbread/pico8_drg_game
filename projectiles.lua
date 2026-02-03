

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
        while (#creatures>=i) do
            while (#bullets>=j) do
                x_pos_good = abs(bullets[j].x_coord-creatures[i].x_coord-3)<2;
                y_pos_good = abs(bullets[j].y_coord-creatures[i].y_coord-4)<4;
                if x_pos_good and y_pos_good then
                    deli(bullets,j);
                else
                    j+=1;
                end
            end
            j=1;
            i+=1;
        end
    end
end


