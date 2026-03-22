function bottom_grunt(x,y)
local frame=rnd(20)
local up_down_frame=rnd(20)
local up_down_cap=rnd(20)+40
local x=x
local y=y
local y0=y
local display_alt=false
local alive=true
local creature_damage=1
local hitbox={x={1,8},y={1,8}}
local function update()
display_alt=frame>15
y=y0+sgn(up_down_frame-up_down_cap/2)
frame=frame%30+1
up_down_frame=(up_down_frame+1)%up_down_cap
end
local function damage(damage_received)
end
local function draw()
spr(1,x,y,1,1,display_alt,true)
end
local function x_f() return x end
local function y_f() return y end
local function is_alive() return alive end
return {
x=x_f,
y=y_f,
update=update,
damage=damage,
creature_damage=creature_damage,
draw=draw,
hitbox=hitbox,
is_alive=is_alive,
}
end
function cave_angel(x,y)
local frame=1
local x=x
local y=y
local damaged_since=0
local was_damaged=false
local x_flip=rnd(2)<1
local health=20
local alive=true
local creature_damage=0
local hitbox={x={2,7},y={1,7}}
local wings_open
local function update()
if game_status=="playing" then
y+=1
if frame%45==0 then x+=sgn(x-player.x) end
if frame%10==0 then y+=1 end
end
wings_open=frame>45
was_damaged, damaged_since = handle_creature_being_damaged(
was_damaged, damaged_since)
frame=frame%60+1
end
local function damage(damage_received)
sfx(33)
was_damaged=true
health-=damage_received
if health<=0 then
alive=false
no_cave_angels_killed=false
end
end
local function draw()
local sprite=11
if was_damaged then sprite+=2 end
if not wings_open then sprite+=1 end
spr(sprite,x,y,1,1,x_flip,false)
end
local function x_f() return x end
local function y_f() return y end
local function is_alive() return alive end
return {
x=x_f,
y=y_f,
update=update,
damage=damage,
creature_damage=creature_damage,
draw=draw,
hitbox=hitbox,
is_alive=is_alive,
}
end
function egg(x,y)
local frame=1
local damaged_since=0
local was_damaged=false
local x=x
local y=y
local display_alt=false
local health=30
local alive=true
local creature_damage=0
local hitbox={x={2,7},y={1,8}}
local function update()
y+=1
if frame%5==0 then y-=1 end
display_alt=frame>10
was_damaged,damaged_since=handle_creature_being_damaged(
was_damaged,damaged_since)
frame = frame%20+1
end
local function damage(damage_received)
sfx(32)
was_damaged=true
health-=damage_received
if health<=0 then
give_ammo(.5)
give_health(1)
player.points+=50
no_scout_killed=false
alive=false
end
end
local function draw()
local sprite=58
if display_alt then sprite+=1 end
if was_damaged then sprite+=2 end
spr(sprite,x,y)
end
local function x_f() return x end
local function y_f() return y end
local function is_alive() return alive end
return {
x=x_f,
y=y_f,
update=update,
damage=damage,
creature_damage=creature_damage,
draw=draw,
hitbox=hitbox,
is_alive=is_alive,
}
end
function grunt(x,y)
local frame=1
local x=x
local y=y
local damaged_since=0
local display_alt=false
local was_damaged=false
local health=40
local alive=true
local creature_damage=1
local hitbox={x={1,8},y={1,8}}
local function update()
if game_status=="playing" then
y+=1
if frame%6==0 then y+=1 end
end
x_flip=frame>15
was_damaged,damaged_since=handle_creature_being_damaged(
was_damaged, damaged_since)
frame=(frame+1)%30
end
local function damage(damage_received)
sfx(33)
was_damaged=true
health-=damage_received
if health<=0 then
alive=false
player.points+=10
end
end
local function draw()
local sprite=1
if was_damaged then sprite+=1 end
spr(sprite,x,y,1,1,x_flip,false)
end
local function x_f() return x end
local function y_f() return y end
local function is_alive() return alive end
return {
x=x_f,
y=y_f,
update=update,
damage=damage,
creature_damage=creature_damage,
draw=draw,
hitbox=hitbox,
is_alive=is_alive,
}
end
function loot_bug(x,y)
local frame=1
local x=x
local y=y
local damaged_since=0
local was_damaged=false
local x_flip=false
local health=30
local alive=true
local creature_damage=0
local hitbox={x={2,7},y={1,7}}
local function update()
if game_status=="playing" then
y+=1
if frame%27==26 then y+=1 end
end
x_flip=frame>15
was_damaged,damaged_since=handle_creature_being_damaged(
was_damaged,damaged_since)
frame=frame%30+1
end
local function damage(damage_received)
sfx(33)
was_damaged=true
health-=damage_received
if health<=0 then
alive=false
give_ammo(.2)
no_lootbugs_killed=false
add_killed_lootbug_name()
end
end
local function draw()
local sprite=44
if was_damaged then sprite+=1 end
spr(sprite,x,y,1,1,x_flip,false)
end
local function x_f() return x end
local function y_f() return y end
local function is_alive() return alive end
return {
x=x_f,
y=y_f,
update=update,
damage=damage,
creature_damage=creature_damage,
draw=draw,
hitbox=hitbox,
is_alive=is_alive,
}
end
function handle_creature_being_damaged(was_damaged, damaged_since)
damaged_since += 1
if damaged_since > damaged_sprite_duration then
was_damaged = false
damaged_since = 0
end
return was_damaged, damaged_since
end
function new_creatures()
local creatures=new_entity_container()
for x=106,220,9 do
creatures.add(bottom_grunt(x,222))
end
local function spawn_creature()
local creature_ratios = game_logic.creature_ratios()
local creature
local x=sample_one(102,118)
local y=81
local creature=choose_from_cum_prob(game_logic.creature_ratios())
creatures.add(creature(x,y))
end
local function update()
local creature
for i=creatures.size(),1,-1 do
creature=creatures.get(i)
creature.update()
if creature.y()>=240 then
creatures.delete(creature)
elseif not creature.is_alive() then
creatures.delete(creature)
end
end
end
local function draw()
for i=1,#creatures do
creatures[i].draw()
end
end
function get_hitbox()
local x1=hitbox.x[1]+x()-1;
local x2=hitbox.x[2]+x()-1;
local y1=hitbox.y[1]+y()-1;
local y2=hitbox.y[2]+y()-1;
return {x={x1,x2},y={y1,y2}};
end
return {
spawn=spawn_creature,
update=update,
draw=draw,
get_hitbox=get_hitbox,
creatures=creatures,
}
end
function mactera(x,y)
local frame=1
local x=x
local y=y
local damaged_since=0
local was_damaged=false
local wings_open=false
local health=20
local alive=true
local did_spit=false
local perform_spit=false
local creature_damage=0
local hitbox={x={2,7},y={1,7}}
local function update()
if game_status=="playing" then
if (player.y_pos-y)<30 and not did_spit then
perform_spit=true
end
if perform_spit then
if frame==0 then
did_spit=true
add_spit("mactera_spit",x,y)
end
if did_spit and frame==0 then
perform_spit=false
end
else
y+=1
if frame%2==0 then y+=1 end
end
if frame%2==0 and not did_spit then x-=sgn(x-player.x_pos) end
end
was_damaged,damaged_since=handle_creature_being_damaged(
was_damaged,damaged_since)
wings_open=frame>8
frame=frame%16+1
end
local function damage(damage_received)
sfx(33)
was_damaged=true
health-=damage_received
if health<=0 then
alive=false
no_cave_angels_killed=false
player.points+=30
end
end
local function draw()
local sprite=27
if wings_open then sprite+=1 end
if was_damaged then sprite+=2 end
spr(sprite,x,y)
end
local function x_f() return x end
local function y_f() return y end
local function is_alive() return alive end
return {
x=x_f,
y=y_f,
update=update,
damage=damage,
creature_damage=creature_damage,
draw=draw,
hitbox=hitbox,
is_alive=is_alive,
}
end
function number(x,y,value)
local value=value
local x = x
local y = y
local health = 1
local alive = true
local creature_damage = 0
local hitbox={x={3,7},y={1,8}}
local function update()
if game_status=="playing" then y+=1 end
end
local function damage(damage_received)
sfx(33)
health-=damage_received
if health<=0 then
difficulty=value
set_hazard_level()
in_tutorial=false
game_status="playing"
music(-1)
music(1)
alive=false
end
end
local function draw()
local b={x={x+hitbox.x[1]-1, x+hitbox.x[2]-1}}
local a={x={player.x_pos+6,player.x_pos+6}}
local sprite=191+value
if a.x[1]>b.x[2] or a.x[2]<b.x[1] then sprite+=16 end
spr(sprite,x,y)
end
local function x_f() return x end
local function y_f() return y end
local function is_alive() return alive end
return {
x=x_f,
y=y_f,
update=update,
damage=damage,
creature_damage=creature_damage,
draw=draw,
hitbox=hitbox,
is_alive=is_alive,
}
end
function praetorian(x,y)
local frame=1
local x=x
local y=y
local damaged_since=0
local x_flip=false
local was_damaged=false
local health=80
local alive=true
local creature_damage=1
local hitbox={x={4,12},y={2,14}}
local spitting=false
local spit
local function update()
if game_status=="playing" then
y+=1
if not spitting and frame%20==0 then y+=1 end
end
if not spitting then x_flip=frame>20 end
was_damaged,damaged_since=handle_creature_being_damaged(
was_damaged,damaged_since)
frame=frame%40+1
if abs(x-player.x()-4)<20 and player.y()-y<20 then
if not spitting then
add_spit("praet_spit",x,y+16)
spitting=true
end
end
end
local function damage(damage_received)
sfx(33)
was_damaged=true
health-=damage_received
if health<=0 then
alive=false
add_spit("praet_cloud",x,y)
del(spits,spit)
player.points+=100
end
end
local function draw()
local sprite=3
if was_damaged then sprite+=2 end
spr(sprite,x,y,2,2,x_flip,false)
end
local function x_f() return x end
local function y_f() return y end
local function is_alive() return alive end
return {
x=x_f,
y=y_f,
update=update,
damage=damage,
creature_damage=creature_damage,
draw=draw,
hitbox=hitbox,
is_alive=is_alive,
}
end
function slasher(x,y)
local frame=1
local x=x
local y=y
local damaged_since=0
local x_flip=false
local was_damaged=false
local health=50
local alive=true
local creature_damage=2
local hitbox={x={1,8},y={1,8}}
local function update()
if game_status=="playing" then
y+=1
if frame%4==0 then y+=1 end
end
x_flip=frame>12
was_damaged,damaged_since=handle_creature_being_damaged(
was_damaged,damaged_since)
frame=frame%24+1
end
local function damage(damage_received)
sfx(33)
was_damaged=true
health-=damage_received
if health<=0 then
alive=false
player.points+=30
end
end
local function draw()
local sprite=17
if was_damaged then sprite+=1 end
spr(sprite,x,y,1,1,x_flip,false)
end
local function x_f() return x end
local function y_f() return y end
local function is_alive() return alive end
return {
x=x_f,
y=y_f,
update=update,
damage=damage,
creature_damage=creature_damage,
draw=draw,
hitbox=hitbox,
is_alive=is_alive,
}
end
function new_entity_container()
local entities={}
local function add_entity(entity)
add(entities,entity)
end
local function get_entities(i)
return entities[i]
end
local function delete_entity(entity)
del(entities,entity)
end
local function deletei_entity(i)
deli(entities,i)
end
local function size_entities()
return #entities
end
local function replace_entity(i,new_entity)
entities[i]=new_entity
end
return {
add=add_entity,
get=get_entities,
delete=delete_entity,
deletei=deletei_entity,
size=size_entities,
replace=replace_entity,
}
end
function new_game_logic()
local obstacle_ratios,resource_ratios,creature_ratios
local function set_difficulty(difficulty)
creature_ratios={
{2,loot_bug},
{1,cave_angel},
{10,grunt},
{1,praetorian},
{2,slasher},
{1,mactera},
}
resource_ratios={
{1,"gold"},
{1,"nitra"},
{1,"red_sugar"},
}
obstacle_ratios={
{15,"small"},
{1,"big"},
}
creature_variety=6
resource_variety=3
obstacle_variety=2
if difficulty==1 then
obstacle_spawn_rate=.04
resource_spawn_rate=.05
creature_spawn_rate=.06
creature_variety=4
resource_variety=1
elseif difficulty==2 then
obstacle_spawn_rate=.2
resource_spawn_rate=.01
creature_spawn_rate=.04
creatre_variety=5
elseif difficulty==3 then
obstacle_spawn_rate=.2
resource_spawn_rate=.01
creature_spawn_rate=.06
elseif difficulty==4 then
obstacle_spawn_rate=.2
resource_spawn_rate=.01
creature_spawn_rate=.06
elseif difficulty==5 then
obstacle_spawn_rate=.2
resource_spawn_rate=.01
creature_spawn_rate=.06
resource_variety=2
end
creature_ratios=get_cum_sum(creature_ratios,creature_variety)
obstacle_ratios=get_cum_sum(obstacle_ratios,obstacle_variety)
resource_ratios=get_cum_sum(resource_ratios,resource_variety)
end
local function mine_resources()
local resource,colliding,drilling_1,drilling_2,res_hitbox
local hitbox_drills_1=player_1.get_drills_hitbox()
local hitbox_drills_2=player_2.get_drills_hitbox()
drilling_1=player_1.is_drilling()
drilling_2=player_2.is_drilling()
if drilling_1 or drilling_2 then
for i=resources.get_resources().size(),1,-1 do
resource=resources.get_resources().get(i)
res_hitbox=resources.get_hitbox(resource)
colliding_1=are_colliding(res_hitbox,hitbox_drills)
if colliding then
local res_type=resource.res_type
if res_type=="red_sugar" then
player_1.give_health(1)
elseif res_type=="nitra" then
player_1.give_ammo(.5)
elseif res_type=="gold" then
points+=100
end
resources.get_resources().deletei(i)
sfx(-1,3)
sfx(38,3)
end
end
end
end
local function update()
mine_resources()
if rnd()<creature_spawn_rate then
creatures.spawn()
end
if rnd()<obstacle_spawn_rate then
map.spawn_obstacle(sample_one(100,120),81)
end
if rnd()<resource_spawn_rate then
resources.spawn(sample_one(102,118),81)
end
end
local function obstacle_ratios_f() return obstacle_ratios end
local function resource_ratios_f() return resource_ratios end
local function creature_ratios_f() return creature_ratios end
return {
update=update,
set_difficulty=set_difficulty,
obstacle_ratios=obstacle_ratios_f,
resource_ratios=resource_ratios_f,
creature_ratios=creature_ratios_f,
}
end
function initialize_game()
music(56);
damaged_sprite_duration = 4;
game_time = 0;
game_status = "title_screen";
no_lootbugs_killed = true;
no_cave_angels_killed = true;
in_tutorial = true;
no_scout_killed = true;
calculate_extra_credits = true;
difficulty = 3;
creature_spawn_rate = 0;
obstacle_spawn_rate = 0;
resource_spawn_rage = 0;
end
function update_game()
game_time += 1;
if game_time%5==0 then player.points += 1 end;
if difficulty == 1 then
if game_time%800==799 then creature_spawn_rate+=.01 end;
if game_time%850==849 then obstacle_spawn_rate+=.01 end;
player.fuel = player.max_fuel;
player.ammo = player.max_ammo;
elseif difficulty == 2 then
if game_time%200==199 then creature_spawn_rate+=.01 end;
if game_time%450==449 then obstacle_spawn_rate+=.01 end;
if game_time%800==799 then resource_spawn_rate+=.01 end;
elseif difficulty == 3 then
if game_time%200==199 then creature_spawn_rate+=.01 end;
if game_time%250==249 then obstacle_spawn_rate+=.01 end;
if game_time%800==799 then resource_spawn_rate+=.01 end;
elseif difficulty == 4 then
if game_time%200==199 then creature_spawn_rate+=.01 end;
if game_time%250==249 then obstacle_spawn_rate+=.01 end;
elseif difficulty == 5 then
if game_time%100==99 then creature_spawn_rate+=.01 end;
if game_time%150==149 then obstacle_spawn_rate+=.01 end;
if game_time%600==599 then resource_spawn_rate-=.01 end;
if resource_spawn_rate<0 then resource_spawn_rate=0 end;
end
if player.health <= 0 then
display_death_screen();
end
end
function snapshot_achievements()
if calculate_extra_credits then
if in_tutorial then player.points+=500 end;
if no_lootbugs_killed then player.points+=100 end;
if no_cave_angels_killed then player.points+=100 end;
if no_scout_killed then player.points+=100 end;
calculate_extra_credits = false;
end
end
function get_cum_probs(ratios)
local sum = 0;
local probs = {};
for ratio in all(ratios) do
add(probs, ratio);
sum+=ratio;
end
for i=1,#probs do
probs[i] = probs[i]/sum;
end
for i=2,#probs do
probs[i] += probs[i-1];
end
return probs;
end
function are_colliding(a, b)
local x_good=a.x[1]>b.x[2] or a.x[2]<b.x[1];
local y_good=a.y[1]>b.y[2] or a.y[2]<b.y[1];
return not(x_good or y_good);
end
function get_player_hitbox(player)
return {
x={player.x+1, player.x+6},
y={player.y, player.y+7},
};
end
function get_bullet_hitbox(bullet)
return {
x={bullet.x+6,bullet.x+6},
y={bullet.y+5,bullet.y+15},
};
end
function get_spit_hitbox(spit)
local x1=spit.hitbox.x[1]+spit.x()-1;
local x2=spit.hitbox.x[2]+spit.x()-1;
local y1=spit.hitbox.y[1]+spit.y()-1;
local y2=spit.hitbox.y[2]+spit.y()-1;
return {x={x1,x2}, y={y1,y2}};
end
function get_drills_hitbox(player)
return {
x={player.x,player.x+7},
y={player.y-1,player.y+3},
};
end
function get_damaging_drills_hitbox(player)
return {
x={player.x,player.x+7},
y={player.y-3,player.y+3},
};
end
function draw_hitbox(hitbox)
pset(hitbox.x[1],hitbox.y[1],8);
pset(hitbox.x[2],hitbox.y[1],8);
pset(hitbox.x[1],hitbox.y[2],8);
pset(hitbox.x[2],hitbox.y[2],8);
end
function new_hud()
local function draw_prog_bar(percentage,x,y)
local green_pixels=flr(percentage*12)
local color
spr(63,x,y)
spr(63,x+6,y)
for i=1,12 do
color=i>green_pixels and 8 or 11
pset(x+i,y+1,color)
end
end
local function draw_hearts(player,x)
for i=1,3 do
if i>player.health() then
pal(8,6)
end
spr(31,x+8*(i-1),180)
pal()
end
end
local function draw(player)
local x=player.number==1 and 105 or 202
draw_hearts(player,x)
spr(46,x,190)
draw_prog_bar(player.ammo()/player.max_ammo,x+9,192)
if player.max_fuel>0 then
spr(47,x,200)
draw_prog_bar(player.fuel()/player.max_fuel,x+9,202)
end
spr(62,x,210)
print(points,x+10,211,7)
end
return {
draw=draw,
}
end
function _init()
player_1=new_player(1)
player_2=new_player(2)
projectiles=new_projectiles()
resources=new_resources()
map=new_map()
hud=new_hud()
title_screen=new_title_screen()
game_logic=new_game_logic()
creatures=new_creatures()
performance_monitor=new_performance_monitor()
end
function _update()
difficulty=2
game_logic.set_difficulty(2)
coop=true
points=0
game_status="playing"
performance_monitor.reset_cpu_load()
projectiles.update()
resources.update()
map.update()
player_1.update()
if coop then player_2.update() end
creatures.update()
game_logic.update()
performance_monitor.register_load()
end
function _draw()
cls(1)
camera(101,101)
map.draw_terrain()
map.draw_wall()
map.draw_obstacles()
map.draw_drilled_ground()
resources.draw()
creatures.draw()
projectiles.draw()
if coop then player_2.draw() end
player_1.draw()
title_screen.draw()
map.draw_vines()
map.draw_super_wall()
hud.draw(player_1)
if coop then hud.draw(player_2) end
performance_monitor.register_load()
performance_monitor.print_current()
end
function new_map()
local function create_wall(x,y)
return {
sprite=64+flr(rnd(4))+16*flr(rnd(4)),
x=x,
y=y,
x_flip=x>140,
y_flip=coinflip(),
swap_gray=coinflip(),
swap_blue=coinflip(),
}
end
local terrain=new_entity_container()
local walls=new_entity_container()
local super_walls=new_entity_container()
local drilled_ground=new_entity_container()
local obstacles=new_entity_container()
local vines=new_entity_container()
for x=102,220,118 do
for y=91,228,8 do
walls.add(create_wall(x,y))
end
end
for i=98,230,130 do
for j=91,228,8 do
super_walls.add({x=i,y=j})
end
end
local function spawn_pebble()
local color=coinflip() and 6 or 2
return {
color=color,
x=flr(rnd(128))+101,
y=94,
}
end
local function spawn_vine()
local sprites={76,78,108,110}
return {
sprite=choose_one(sprites),
x=flr(rnd(112))+101,
y=81,
x_flip=coinflip(),
y_flip=coinflip(),
}
end
local function spawn_drilled_ground(sprite,x,y)
drilled_ground.add({sprite=sprite,x=x,y=y})
end
local function spawn_obstacle(x,y)
local sprite,sprites,size
local decision=choose_from_cum_prob(game_logic.obstacle_ratios())
if decision=="small" then
sprites={68,69,70,71,84,85,86,87,100,101,116,117}
size=1
else
sprites={72,74,102,104,106}
size=2
end
sprite=choose_one(sprites)
return {
sprite=sprite,
x=x,
y=y,
size=size,
x_flip=coinflip(),
y_flip=coinflip(),
}
end
local function update()
local wall,terrain_piece
if game_status=="playing" then
for i=1,walls.size() do
wall=walls.get(i)
wall.y+=1
if wall.y>=230 then
walls.replace(i,create_wall(wall.x,91))
end
end
for i=terrain.size(),1,-1 do
terrain_piece=terrain.get(i)
terrain_piece.y+=1
if terrain_piece.y>230 then
terrain.deletei(i)
end
end
remove_bottom_entities(drilled_ground,drilled_ground.y)
if rnd()<.8 then
terrain.add(spawn_pebble())
end
for i=obstacles.size(),1,-1 do
obstacles.get(i).y+=1
if obstacles.get(i).y>=230 then
obstacles.deletei(i)
end
end
for i=vines.size(),1,-1 do
vines.get(i).y+=1
if vines.get(i).y>=230 then
vines.deletei(i)
end
end
if rnd()<.05 then
vines.add(spawn_vine())
end
end
end
local function draw_wall()
local wall
for i=1,walls.size() do
wall=walls.get(i)
if wall.swap_gray then pal(6,13) end
if wall.swap_blue then pal(13,6) end
spr(
wall.sprite,
wall.x,
wall.y,
1,1,
wall.x_flip,
wall.y_flip
)
pal()
end
end
local function draw_super_wall()
for i=1,super_walls.size() do
spr(
61,
super_walls.get(i).x,
super_walls.get(i).y,
1,1,false,false
)
end
end
local function draw_terrain()
local terrain_piece
for i=1,terrain.size() do
terrain_piece=terrain.get(i)
pset(terrain_piece.x,terrain_piece.y,terrain_piece.color)
end
end
local function draw_drilled_ground()
local ground_piece
for i=1,drilled_ground.size() do
ground_piece=drilled_ground.get(i)
spr(ground_piece.sprite,ground_piece.x,ground_piece.y)
end
end
local function draw_obstacles()
local obstacle
for i=1,obstacles.size() do
obstacle=obstacles.get(i)
spr(
obstacle.sprite,
obstacle.x,
obstacle.y,
obstacle.size,
obstacle.size,
obstacle.x_flip,
obstacle.y_flip
)
end
end
local function draw_vines()
local vine
for i=1,vines.size() do
vine=vines.get(i)
spr(vine.sprite,vine.x,vine.y,2,2,vine.x_flip,vine.y_flip)
end
end
return {
update=update,
draw_wall=draw_wall,
draw_super_wall=draw_super_wall,
draw_terrain=draw_terrain,
draw_drilled_ground=draw_drilled_ground,
draw_obstacles=draw_obstacles,
draw_vines=draw_vines,
spawn_drilled_ground=spawn_drilled_ground,
add_obstacle=obstacles.add,
spawn_obstacle=spawn_obstacle,
}
end
function new_performance_monitor()
local cpu_percentage = 0;
local max_cpu_percentage = 0;
local min_fps = 60;
function reset_cpu_load()
cpu_percentage = 0;
end
function register_load()
cpu_percentage += stat(1);
max_cpu_percentage = max(cpu_percentage, max_cpu_percentage);
end
function print_summary()
info = flr(max_cpu_percentage*100)/100;
print("cpu spike: "..info, 150, 200);
print("fps low:   "..min_fps);
end
function print_current()
print(stat(7), 218, 103, 11);
min_fps = min(stat(7),min_fps);
end
return {
register_load = register_load,
print_summary = print_summary,
print_current = print_current,
reset_cpu_load = reset_cpu_load,
};
end
function new_player(number)
local x=148
local y=200
local is={
moving={up,down,left,right},
shooting=false,
drilling=false,
mining=false,
rns=false}
local was_mining=false
local mined_since=0
local playing={drill_sound=false,gun_sound=false}
local moving_frame=0
local points=0
local ammo=number==1 and 25 or 100
local fuel=number==1 and 150 or 0
local max_ammo=number==1 and 25 or 100
local max_fuel=number==1 and 150 or 0
local shots_fired=false
local shot_delay_counter=0
local max_shot_delay=number==1 and 3 or 1
local health=3
local max_health=3
local is_hit=false
local hit_since=0
local has_invuln=false
local invuln_duration=30
local collision_points={left={},right={},top={}}
local has_collision={left=false,right=false,top=false}
local number=number
for i=1,8 do
add(collision_points.left,{x=0,y=0})
add(collision_points.right,{x=0,y=0})
add(collision_points.top,{x=0,y=0})
end
local function fetch_inputs()
local p=number-1
is.moving.up=btn(2,p)
is.moving.down=btn(3,p)
is.moving.left=btn(0,p)
is.moving.right=btn(1,p)
is.shooting=btn(5,p) and not btn(4,p)
local drilling_button=btn(4,p) and not btn(5,p)
is.rns=btn(3,p) and btn(4,p) and btn(5,p)
is.drilling=drilling_button and fuel>0
local mining_button=drilling_button and fuel<=0
is.mining=mining_button and not was_mining
if is.mining then mined_since=0 end
was_mining=mining_button or mined_since<5
mined_since+=1
end
local function update_player_collision_points()
for i=1,6 do
collision_points.left[i].x=x
collision_points.left[i].y=y+i
end
for i=1,6 do
collision_points.right[i].x=x+7
collision_points.right[i].y=y+i
end
for i=1,6 do
collision_points.top[i].x=x+i
collision_points.top[i].y=y-1
end
end
local function find_terrain_collision()
local point,color
has_collision.left=false
has_collision.right=false
has_collision.top=false
for i=1,#collision_points.left do
point=collision_points.left[i]
color=pget(point.x,point.y)
if color==5 or color==13 then
has_collision.left=true
break
end
end
for i=1,#collision_points.right do
point=collision_points.right[i]
color=pget(point.x,point.y)
if color==5 or color==13 then
has_collision.right=true
break
end
end
for i=1,#collision_points.top do
point=collision_points.top[i]
color=pget(point.x,point.y)
if color==5 or color==13 then
has_collision.top=true
break
end
end
end
local function mine()
map.spawn_drilled_ground(53,x,y-2)
sfx(-1,number)
sfx(31,number)
end
local function drill()
if fuel>0 then
map.spawn_drilled_ground(52,x,y-2)
fuel-=1
if not playing.drill_sound then
sfx(-1,number)
sfx(30,number)
playing.drill_sound=true
end
end
end
local function shoot()
if ammo > 0 then
projectiles.fire_bullet(number)
ammo-=1
if not playing.gun_sound and number==2 then
sfx(-1,number)
sfx(36,number)
playing.gun_sound=true
elseif number==1 then
sfx(-1,number)
sfx(34,number)
end
else
sfx(-1,number)
sfx(35,number)
end
shots_fired=true
end
local function give_ammo(percentage)
ammo+=ceil(max_ammo*percentage)
fuel+=ceil(max_fuel*percentage)
if ammo>max_ammo then ammo=max_ammo end
if fuel>max_fuel then fuel=max_fuel end
end
local function give_health(amount)
health+=amount
if health>max_health then health=max_health end
end
local function give_points(amount) points+=amount end
local function move_player()
if is.moving.up and not has_collision.top then
if y>102 then
y-=1
end
end
if is.moving.down then
if y<221 then
y+=1
end
end
if is.moving.left and not has_collision.left then
if x>=102 then
x-=1
end
end
if is.moving.right and not has_collision.right then
if x<=220 then
x+=1
end
end
if has_collision.top then
y+=1
end
if y<=102 then y=102 end
if y>=221 then y=221 end
end
local function update()
fetch_inputs()
update_player_collision_points()
find_terrain_collision()
move_player()
if is.drilling then
drill()
else
if playing.drill_sound then
sfx(-1,number)
playing.drill_sound=false
end
end
if is.mining then mine() end
if shots_fired and shot_delay_counter<max_shot_delay then
shot_delay_counter+=1
else
shots_fired=false
shot_delay_counter=0
if is.shooting then
shoot()
else
if playing.gun_sound then
sfx(-1,number)
playing.gun_sound=false
end
end
end
end
local function get_hitbox()
return {
x={x+1,x+6},
y={y,y+7},
};
end
local function get_drills_hitbox()
return {
x={x,x+7},
y={y-1,y+3},
};
end
local function get_damaging_drills_hitbox()
return {
x={x,x+7},
y={y-3,y+3},
};
end
local function check_if_hit_by_creature()
local player_box = get_player_hitbox(player)
local creature_box
local no_creatures = #creatures
if no_creatures>0 and not player.is_drilling then
for i=1,no_creatures do
creature_box = get_creature_hitbox(creatures[i])
if are_colliding(player_box, creature_box) then
if creatures[i].creature_damage>0 and not player.has_invuln then
player.health -= creatures[i].creature_damage
player.is_hit = true
player.hit_since = 0
player.has_invuln = true
end
end
end
end
end
local function handle_being_hit()
if player.is_hit and player.hit_since>player.invuln_duration then
player.hit_since = 0
player.is_hit = false
player.has_invuln = false
elseif player.is_hit and player.hit_since<=player.invuln_duration then
player.hit_since+=1
end
if player.is_hit and player.hit_since == 1 then
sfx(32)
end
if player.health <= 0 then game_status = "end_screen" end
end
local function draw_gun()
pset(x+6,y,5)
pset(x+6,y+1,5)
if number==2 then
pset(x+5,y,5)
pset(x+7,y,5)
pset(x+7,y+1,5)
pset(x+7,y+2,5)
pset(x+7,y+3,5)
pset(x+7,y+4,5)
end
end
local function draw_drills()
pset(x+6,y,5)
pset(x+6,y+1,5)
pset(x+5,y,5)
pset(x+2,y,5)
pset(x+1,y,5)
pset(x+1,y+1,5)
end
local function draw_pickaxe()
pset(x+6,y,5)
pset(x+6,y+1,4)
pset(x+6,y+2,4)
end
local function draw()
local moving,x_flip
if game_status=="playing" then
moving=(not is.moving.down
or is.moving.left or is.moving.right)
elseif game_status=="title_screen" then
moving=(is.moving.down or is.moving.up
or is.moving.left or is.moving.right)
end
local sprite=number==1 and 48 or 32
local speed=1
if game_status=="playing" and is.moving.up then speed=2 end
if moving then sprite+=1 end
x_flip=moving_frame>=8
moving_frame=(moving_frame+speed)%16
if is_hit then pal(8,10) end
spr(sprite,x,y,1,1,x_flip,false)
pal()
if is.shooting then draw_gun() end
if is.drilling then draw_drills() end
if is.mining or was_mining then draw_pickaxe() end
end
local function x_f() return x end
local function y_f() return y end
local function drilling_f() return is.drilling or is.mining end
local function shooting_f() return is.shooting end
local function rns_f() return is.rns end
local function hit_f() return is_hit end
local function health_f() return health end
local function ammo_f() return ammo end
local function fuel_f() return fuel end
return {
x=x_f,
y=y_f,
update=update,
draw=draw,
give_ammo=give_ammo,
give_health=give_health,
give_points=give_points,
get_hitbox=get_hitbox,
get_drills_hitbox=get_drills_hitbox,
get_damaging_drills_hitbox=get_damaging_drills_hitbox,
is_drilling=drilling_f,
is_shooting=shooting_f,
is_rns=rns_f,
is_hit=hit_f,
health=health_f,
number=number,
ammo=ammo_f,
fuel=fuel_f,
max_ammo=max_ammo,
max_fuel=max_fuel,
}
end
function new_projectiles()
local bullets=new_entity_container()
local spits=new_entity_container()
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
local function fire_bullet(number)
player=number==1 and player_1 or player_2
bullets.add({x=player.x(),y=(player.y())-8})
end
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
function spawn_prop()
local x=flr(rnd(120))+101
local y=81
local decision=rnd(100)
local prop
if decision<50 then
prop=nectar_rind(x,y)
elseif decision<80 then
prop=orchey_shy(x,y)
else
prop=p0q(x,y)
end
add(props, prop)
end
function nectar_rind(x,y)
local sprite
local x = x
local y = y
local x_flip = coinflip()
local y_flip = coinflip()
function animate()
y+=1
local distance = (player.x_pos-x)^2 + (player.y_pos-y)^2
if distance < 30^2 then
sprite = 173
else
sprite = 172
end
end
function draw()
spr(sprite, x, y, 1, 1, x_flip, y_flip)
end
function x_coord() return x end
function y_coord() return y end
return {
x_coord=x_coord,
y_coord=y_coord,
animate=animate,
draw=draw,
}
end
function orchey_shy(x, y)
local sprite
local x = x
local y = y
local x_flip = coinflip()
local y_flip = coinflip()
function animate()
y+=1
local distance = (player.x_pos-x)^2 + (player.y_pos-y)^2
if distance < 225 then
sprite = 190
elseif distance < 900 then
sprite = 189
else
sprite = 188
end
end
function draw()
spr(sprite, x, y, 1, 1, x_flip, y_flip)
end
function x_coord() return x end
function y_coord() return y end
return {
x_coord=x_coord,
y_coord=y_coord,
animate=animate,
draw=draw,
}
end
function p0q(x, y)
local sprite = 140
local x = x
local y = y
local x_flip = coinflip()
local y_flip = coinflip()
local angle = 0
local parts = {}
local n = 30
local initial_angle
local r2d = 3.14/180
for i=1,n do
initial_angle = 360*i/n
radius = ceil(rnd(12))
add(parts,{radius=radius, angle=initial_angle})
end
function animate()
y+=1
angle = (angle+.25)%360
end
function draw()
spr(sprite, x, y, 2, 2, x_flip, y_flip)
local x_pos, y_pos
for i=1,n do
x_pos = ceil(parts[i].radius*cos((angle+parts[i].angle)*r2d))
y_pos = ceil(parts[i].radius*sin((angle+parts[i].angle)*r2d))
pset(x_pos+x+8, y_pos+y+8, 12)
end
end
function x_coord() return x end
function y_coord() return y end
return {
x_coord=x_coord,
y_coord=y_coord,
animate=animate,
draw=draw,
}
end
function initialize_props()
props = {}
end
function update_props()
if #props>0 then
for prop in all(props) do
prop.animate()
end
local i=1
while #props>=i do
if props[i].y_coord() >= 240 then
deli(props, i)
else
i+=1
end
end
end
if rnd() < .02 then
spawn_prop()
end
end
function draw_props()
if #props>0 then
for prop in all(props) do
prop.draw()
end
end
end
function new_resources()
local list=new_entity_container()
local function spawn_resource(x,y)
local sprite,sprites,hitbox,res_type,start_sprite
local res_type=choose_from_cum_prob(game_logic.resource_ratios())
if res_type=="red_sugar" then
start_sprite=136
hitbox={x={3,6},y={3,6}}
elseif res_type=="nitra" then
start_sprite=152
hitbox={x={1,8},y={1,8}}
else
start_sprite=168
hitbox={x={1,8},y={1,8}}
end
sprite=start_sprite+flr(rnd(4))
return {
sprite=sprite,
x=x,
y=y,
x_flip=coinflip(),
y_flip=coinflip(),
hitbox=hitbox,
res_type=res_type,
}
end
local function update()
for i=list.size(),1,-1 do
list.get(i).y+=1
if list.get(i).y>=230 then
list.deletei(i)
end
end
end
local function mine(hitbox_drills)
local resource
for i=resources.size(),1,-1 do
resource=list.get(i)
if are_colliding(get_hitbox(resource),hitbox_drills) then
local res_type=resource.res_type
if res_type=="red_sugar" then
player.give_health(1)
elseif res_type=="nitra" then
player.give_ammo(.5)
elseif res_type=="gold" then
points+=100
end
list.deletei(i)
sfx(-1,3)
sfx(38,3)
end
end
end
local function get_hitbox(resource)
local x1=resource.x+resource.hitbox.x[1]-1;
local x2=resource.x+resource.hitbox.x[2]-1;
local y1=resource.y+resource.hitbox.y[1]-1;
local y2=resource.y+resource.hitbox.y[2]-1;
return {x={x1,x2},y={y1,y2}};
end
local function draw()
local sprite,x,y,x_flip,y_flip,resource
for i=1,list.size() do
resource=list.get(i)
sprite=resource.sprite
x=resource.x
y=resource.y
x_flip=resource.x_flip
y_flip=resource.y_flip
spr(sprite,x,y,1,1,x_flip,y_flip)
end
end
local function list_f() return list end
return {
update=update,
draw=draw,
get_hitbox=get_hitbox,
get_resources=list_f,
spawn_resource=spawn_resource,
}
end
function new_title_screen()
local function initialize()
map.add_obstacle({sprite=101,x_coord=200,y_coord=160,
size=2,x_flip=false,y_flip=false})
map.add_obstacle({sprite=84,x_coord=200,y_coord=155,
size=1,x_flip=false,y_flip=true})
end
local function draw_controls()
local x0=160
local y0=200
spr(227,x0+16,y0,2,2)
spr(229,x0,y0,2,2)
map.add_obstacle({
sprite=229,
x=x0+16,
y=y0,
size=2,
x_flip=false,
y_flip=false})
end
local function draw()
draw_controls()
end
return {
initialize=initialize,
draw=draw,
}
end
function are_colliding(a, b)
local x_good = a.x[1]>b.x[2] or a.x[2]<b.x[1]
local y_good = a.y[1]>b.y[2] or a.y[2]<b.y[1]
return not(x_good or y_good)
end
function coinflip() return rnd(2)<1 end
function sample_one(first,last) return first+flr(rnd(last+1)) end
function choose_one(list) return list[flr(rnd(#list))+1] end
function choose_from_cum_prob(ratios)
local decision=rnd(ratios.cum_sum)
for i=1,ratios.variety do
if decision<ratios.ratios[i][1] then
decision-=ratios.ratios[i][1]
else
return ratios.ratios[i][2]
end
end
end
function get_cum_sum(ratios,variety)
local sum=0
for i=1,variety do
sum+=ratios[i][1]
end
local new_ratios={}
new_ratios.ratios=ratios
new_ratios.cum_sum=sum
new_ratios.variety=variety
return new_ratios
end
function remove_bottom_entities(container,y_getter)
local entity
for i=container.size(),1,-1 do
entity=container.get(i)
if y_getter>=240 then
container.delete(entity)
end
end
end
