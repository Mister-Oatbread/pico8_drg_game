

function _init()
    player=new_player()
    projectiles=new_projectiles()
    drilled_ground=new_drilled_ground()
end

function _update()
    player.update()
    drilled_ground.update()
    projectiles.update()
end

function _draw()
    cls(1)
    camera(101,101)
    drilled_ground.draw()
    player.draw()
    projectiles.draw()
end


