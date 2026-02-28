

-- takes two objects a,b of the form {x1,x2,y1,y2}, and states
-- whether their hitboxes overlap at any point
-- note that k2>k1
function are_colliding(a, b)
    local x_good=a.x[1]>b.x[2] or a.x[2]<b.x[1];
    local y_good=a.y[1]>b.y[2] or a.y[2]<b.y[1];
    return not(x_good or y_good);
end

-- takes in player and returns hitbox ready to be processed by are_colliding()
function get_player_hitbox(player)
    return {
        x={player.x+1, player.x+6},
        y={player.y, player.y+7},
    };
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

-- takes in player and returns hitbox ready to be processed by are_colliding()
-- but for the drills instead of the player
function get_drills_hitbox(player)
    return {
        x={player.x,player.x+7},
        y={player.y-1,player.y+3},
    };
end

-- hitbox for hitting creatures
function get_damaging_drills_hitbox(player)
    return {
        x={player.x,player.x+7},
        y={player.y-3,player.y+3},
    };
end


-- paints funny dots at the border of the hitboxes, for debugging only
function draw_hitbox(hitbox)
    pset(hitbox.x[1],hitbox.y[1],8);
    pset(hitbox.x[2],hitbox.y[1],8);
    pset(hitbox.x[1],hitbox.y[2],8);
    pset(hitbox.x[2],hitbox.y[2],8);
end


