

-- takes two objects a,b of the form {x1,x2,y1,y2}, and states
-- whether their hitboxes overlap at any point
-- note that k2>k1
function are_colliding(a, b)
    local x_good = a.x[1] > b.x[2] or a.x[2] < b.x[1];
    local y_good = a.y[1] > b.y[2] or a.y[2] < b.y[1];
    return not(x_good or y_good);
end

-- takes in player and returns hitbox ready to be processed by are_colliding()
function get_player_hitbox(player)
    return {
        x={player.x_pos+1, player.x_pos+6},
        y={player.y_pos, player.y_pos+7},
    };
end

-- takes in bullet and returns hitbox ready to be processed by are_colliding()
function get_bullet_hitbox(bullet)
    return {
        x={bullet.x_coord+6,bullet.x_coord+6},
        y={bullet.y_coord+5,bullet.y_coord+15},
    };
end

-- takes in player and returns hitbox ready to be processed by are_colliding()
-- but for the drills instead of the player
function get_drills_hitbox(player)
    return {
        x={player.x_pos, player.x_pos+7},
        y={player.y_pos-1, player.y_pos+3},
    };
end

-- takes in creature and returns hitbox ready to be processed by are_colliding()
function get_creature_hitbox(creature)
    local x1 = creature.hitbox.x[1]+creature.x_coord()-1;
    local x2 = creature.hitbox.x[2]+creature.x_coord()-1;
    local y1 = creature.hitbox.y[1]+creature.y_coord()-1;
    local y2 = creature.hitbox.y[2]+creature.y_coord()-1;
    return {x={x1,x2}, y={y1,y2}};
end

-- takes in resource and retursn hitbox ready to be processed by are_colliding()
function get_resource_hitbox(resource)
    local x1 = resource.x_coord+resource.hitbox.x[1]-1;
    local x2 = resource.x_coord+resource.hitbox.x[2]-1;
    local y1 = resource.y_coord+resource.hitbox.y[1]-1;
    local y2 = resource.y_coord+resource.hitbox.y[2]-1;
    return {x={x1,x2}, y={y1,y2}};
end

-- paints funny dots at the border of the hitboxes, for debugging only
function draw_hitbox(hitbox)
    pset(hitbox.x[1],hitbox.y[1],8);
    pset(hitbox.x[2],hitbox.y[1],8);
    pset(hitbox.x[1],hitbox.y[2],8);
    pset(hitbox.x[2],hitbox.y[2],8);
end


