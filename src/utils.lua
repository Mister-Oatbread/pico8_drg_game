

-- takes two objects a,b of the form {x1,x2,y1,y2}, and states
-- whether their hitboxes overlap at any point
-- note that k2>k1
function are_colliding(a, b)
    local x_good = a.x[1] > b.x[2] or a.x[2] < b.x[1];
    local y_good = a.y[1] > b.y[2] or a.y[2] < b.y[1];
    return not(x_good or y_good);
end


