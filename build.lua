function bottom_grunt(x,y)
local frame=flr(rnd(20))
local up_down_frame=flr(rnd(20))
local up_down_cap=sample_one(20,40)
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
local function damage(damage_received,player)
end
local function draw()
spr(1,x,y,1,1,display_alt,true)
end
return {
update=update,
damage=damage,
creature_damage=creature_damage,
draw=draw,
hitbox=hitbox,
x=function() return x end,
y=function() return y end,
is_alive=function() return alive end,
}
end
function cave_angel(x,y)
local frame=1
local x=x
local y=y
local damaged_since=60
local x_flip=rnd(2)<1
local health=20
local alive=true
local creature_damage=0
local hitbox={x={2,7},y={1,7}}
local wings_open
local tracked_player=choose_one(players)
local function update()
if playing then
y+=1
if frame%45==0 then x+=sgn(x-tracked_player.x()) end
if frame%30==0 then y+=1 end
end
wings_open=frame>45
damaged_since+=1
frame=frame%60+1
end
local function damage(damage_received,player)
sfx(33)
damaged_since=0
health-=damage_received
if health<=0 then
alive=false
no_cave_angels_killed=false
end
end
local function draw()
local sprite=14
if damaged_since<15 then pal(12,2) end
if not wings_open then sprite+=1 end
spr(sprite,x,y,1,1,x_flip,false)
pal()
end
return {
update=update,
damage=damage,
creature_damage=creature_damage,
draw=draw,
hitbox=hitbox,
x=function() return x end,
y=function() return y end,
is_alive=function() return alive end,
}
end
function egg(x,y)
local frame=1
local damaged_since=60
local x=x
local y=y
local health=30
local alive=true
local creature_damage=0
local hitbox={x={2,7},y={1,8}}
local function update()
y+=1
if frame%5==0 then y-=1 end
damaged_since+=1
frame=frame%10+1
end
local function damage(damage_received,player)
sfx(32)
health-=damage_received
damaged_since=0
if health<=0 then
player.give_ammo(.5)
player.give_health(1)
player.give_points(50)
no_scout_killed=false
alive=false
end
end
local function draw()
local x_flip=frame>5
if damaged_since<15 then pal(12,2) end
spr(51,x,y,1,1,x_flip,false)
pal()
end
return {
update=update,
damage=damage,
creature_damage=creature_damage,
draw=draw,
hitbox=hitbox,
x=function() return x end,
y=function() return y end,
is_alive=function() return alive end,
}
end
function grunt(x,y)
local frame=1
local x=x
local y=y
local damaged_since=60
local health=40
local alive=true
local creature_damage=1
local hitbox={x={1,8},y={1,8}}
local function update()
if playing then
y+=1
if frame%6==0 then y+=1 end
end
damaged_since+=1
frame=frame%12+1
end
local function damage(damage_received,player)
sfx(33)
damaged_since=0
health-=damage_received
if health<=0 then
alive=false
player.give_points(10)
end
end
local function draw()
if damaged_since<15 then pal(4,2) end
local x_flip=frame>6
spr(1,x,y,1,1,x_flip,false)
pal()
end
return {
update=update,
damage=damage,
creature_damage=creature_damage,
draw=draw,
hitbox=hitbox,
x=function() return x end,
y=function() return y end,
is_alive=function() return alive end,
}
end
function loot_bug(x,y)
local frame=1
local x=x
local y=y
local damaged_since=60
local health=30
local alive=true
local creature_damage=0
local hitbox={x={2,7},y={1,7}}
local function update()
if playing then
y+=1
if frame%30==0 then y+=1 end
end
damaged_since+=1
frame=frame%60+1
end
local function damage(damage_received,player)
sfx(33)
damaged_since=0
health-=damage_received
if health<=0 then
alive=false
player.give_ammo(.2)
no_lootbugs_killed=false
end
end
local function draw()
local sprite=30
local x_flip=frame>30
if damaged_since<15 then pal(15,2) end
spr(sprite,x,y,1,1,x_flip,false)
pal()
end
return {
update=update,
damage=damage,
creature_damage=creature_damage,
draw=draw,
hitbox=hitbox,
x=function() return x end,
y=function() return y end,
is_alive=function() return alive end,
}
end
function new_creatures()
local creatures_list=new_entity_container()
for x=106,220,9 do
creatures_list.add(bottom_grunt(x,222))
end
local function spawn_creature()
local creature
local x=sample_one(102,118)
local y=81
creature=pick_spawn(game_logic.creature_spawn_params())
creatures_list.add(creature(x,y))
end
local function update()
local creature
for i=creatures_list.size(),1,-1 do
creature=creatures_list.get(i)
creature.update()
if creature.y()>=240 then
creatures_list.delete(creature)
elseif not creature.is_alive() then
creatures_list.delete(creature)
end
end
end
local function draw()
for i=1,creatures_list.size() do
creatures_list.get(i).draw()
end
end
function get_hitbox(creature)
local x1=creature.hitbox.x[1]+creature.x()-1;
local x2=creature.hitbox.x[2]+creature.x()-1;
local y1=creature.hitbox.y[1]+creature.y()-1;
local y2=creature.hitbox.y[2]+creature.y()-1;
return {x={x1,x2},y={y1,y2}};
end
return {
spawn=spawn_creature,
update=update,
draw=draw,
get_hitbox=get_hitbox,
creatures_list=creatures_list,
}
end
function mactera(x,y)
local frame=sample_one(1,60)
local spit_countdown=sample_one(15,30)
local x=x
local y=y
local damaged_since=60
local health=20
local alive=true
local did_spit=false
local performing_spit=false
local creature_damage=0
local hitbox={x={2,7},y={1,7}}
local tracked_player=choose_one(players)
local function update()
if did_spit then
y+=1
if frame%2==0 then y+=1 end
elseif performing_spit then
if frame%2==0 then x-=sgn(x-tracked_player.x()) end
spit_countdown-=1
if spit_countdown==1 then
did_spit=true
performing_spit=false
projectiles.spit_spit("mactera_spit",x,y)
end
else
y+=1
if frame%2==0 then
y+=1
x-=sgn(x-tracked_player.x())
end
performing_spit=tracked_player.y()-y<30
end
damaged_since+=1
frame=frame%16+1
end
local function damage(damage_received,player)
sfx(33)
damaged_since=0
health-=damage_received
if health<=0 then
alive=false
no_cave_angels_killed=false
player.give_points(30)
end
end
local function draw()
local sprite=17
if frame>8 then sprite+=1 end
if damaged_since<15 then pal(3,2) end
spr(sprite,x,y)
pal()
end
return {
update=update,
damage=damage,
creature_damage=creature_damage,
draw=draw,
hitbox=hitbox,
x=function() return x end,
y=function() return y end,
is_alive=function() return alive end,
}
end
function menace(x,y)
local frame=0
local x=x
local y=y
local x_flip=false
local y_flip=false
local damaged_since=60
local health=60
local alive=true
local creature_damage=0
local hitbox={x={1,8},y={1,8}}
local tracked_player=choose_one(players)
local function update()
if playing then
y+=1
end
x_flip=tracked_player.x()-x>0
y_flip=tracked_player.y()-y>0
if frame%10==1 then
local x_shot_position=x_flip and x+8 or x
local y_shot_position=y_flip and y+8 or y
local angle=atan2(
tracked_player.x()-x_shot_position+3,
tracked_player.y()-y_shot_position+3
)
local x_vel=2*cos(angle)
local y_vel=2*sin(angle)+1
projectiles.add_menace_spit(
x_shot_position,
y_shot_position,
x_vel,
y_vel
)
end
frame=frame%10+1
damaged_since+=1
end
local function damage(damage_received,player)
sfx(33)
damaged_since=0
health-=damage_received
x_flip=frame>6
if health<=0 then
alive=false
player.give_points(10)
end
end
local function draw()
if damaged_since<15 then pal(12,2) end
spr(11,x,y,1,1,x_flip,y_flip)
pal()
end
return {
update=update,
damage=damage,
creature_damage=creature_damage,
draw=draw,
hitbox=hitbox,
x=function() return x end,
y=function() return y end,
is_alive=function() return alive end,
}
end
function oppressor(x,y)
local frame=1
local x=x
local y=y
local alive=true
local creature_damage=1
local hitbox={x={2,15},y={1,14}}
local function update()
if playing then
y+=1
if frame%30==0 then y+=1 end
end
frame=frame%60+1
end
local function damage(damage_received,player)
end
local function draw()
local x_flip=frame>30
spr(5,x,y,2,2,x_flip,false)
end
return {
update=update,
damage=damage,
creature_damage=creature_damage,
draw=draw,
hitbox=hitbox,
x=function() return x end,
y=function() return y end,
is_alive=function() return alive end,
}
end
function praetorian(x,y)
local frame=1
local x=x
local y=y
local damaged_since=60
local health=80
local alive=true
local creature_damage=1
local hitbox={x={4,12},y={2,14}}
local spitting=false
local spit
local function update()
if playing then
y+=1
if not spitting and frame%20==0 then y+=1 end
end
if not spitting then x_flip=frame>20 end
damaged_since+=1
if not spitting then frame=frame%40+1 end
for player in all(players) do
if abs(x-player.x()-4)<20 and player.y()-y<20 then
if not spitting then
projectiles.spit_spit("praet_spit",x,y+16)
spitting=true
end
end
end
end
local function damage(damage_received,player)
sfx(33)
damaged_since=0
health-=damage_received
if health<=0 then
alive=false
projectiles.spit_spit("praet_cloud",x,y)
del(spits,spit)
player.give_points(100)
end
end
local function draw()
local x_flip=frame>20
if damaged_since<15 then pal(3,2) end
spr(3,x,y,2,2,x_flip,false)
pal()
end
return {
update=update,
damage=damage,
creature_damage=creature_damage,
draw=draw,
hitbox=hitbox,
x=function() return x end,
y=function() return y end,
is_alive=function() return alive end,
}
end
function slasher(x,y)
local frame=1
local x=x
local y=y
local damaged_since=60
local health=50
local alive=true
local creature_damage=2
local hitbox={x={1,8},y={1,8}}
local function update()
if playing then
y+=1
if frame%4==0 then y+=1 end
end
damaged_since+=1
frame=frame%8+1
end
local function damage(damage_received,player)
sfx(33)
damaged_since=0
health-=damage_received
if health<=0 then
alive=false
player.give_points(30)
end
end
local function draw()
local x_flip=frame>4
if damaged_since<15 then pal(4,2) end
spr(2,x,y,1,1,x_flip,false)
pal()
end
return {
update=update,
damage=damage,
creature_damage=creature_damage,
draw=draw,
hitbox=hitbox,
x=function() return x end,
y=function() return y end,
is_alive=function() return alive end,
}
end
function new_death_screen()
local loot_bug_names={
"steeve",
"jimini",
"jebediah",
"david",
"eva",
"lloyd",
"molly",
"randy",
"jimothy",
"geoff",
"thorben",
"emilia",
"olliver",
"matilda",
"benjamin",
"elodie",
"julien",
"amelia",
"sebby",
"charlie",
"rosalie",
"freddie",
"isabelle",
"tobias",
"lucien",
"henry",
"maxime",
"oliver",
"samuel",
"august",
"finnley",
"steevie",
}
local killed_loot_bugs=new_entity_container()
local function initialize()
end
local function report_killed_lootbug()
killed_loot_bugs.add(choose_one(loot_bug_names))
end
local function draw()
sfx(-1,0)
sfx(-1,1)
sfx(-1,2)
sfx(-1,3)
for i=1,#players do
players[i].x=130+8*i
players[i].y=182
end
print("awards:", 111,126,7)
print("",113,126,7)
if no_lootbugs_killed then
print("-no lootbugs")
print(" killed (+100)")
end
if no_cave_angels_killed then
print("-no cave angels")
print(" killed (+100)")
end
if no_scout_killed then
print("-you spared")
print(" the scouts (+100)")
end
if in_tutorial then
print("-died during the")
print(" tutorial (+500)")
end
if not no_lootbugs_killed then
print("killed",190,130,7)
print("loot")
print("bugs:")
local y = 148
for name in all(killed_loot_bugs) do
print(name,192,y)
y+=6
end
end
local points_total=0
for i=1,#players do points_total+=players[i].points() end
print("game over!", 120, 105, 7)
print("score: "..points_total)
end
return {
report_killed_lootbug=report_killed_lootbug,
draw=draw,
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
local obstacle_spawn_rate,resource_spawn_rate,creature_spawn_rate=0,0,0
local timer=0
local function set_difficulty(difficulty)
if at_title_screen then
creature_ratios={
{2,loot_bug},
{1,cave_angel},
{10,grunt},
{1,praetorian},
{2,slasher},
{1,mactera},
{1,menace},
{1,oppressor},
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
creature_variety=8
resource_variety=3
obstacle_variety=2
if difficulty==1 then
obstacle_spawn_rate=.08
resource_spawn_rate=.05
creature_spawn_rate=.04
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
creature_spawn_params=generate_spawn_params(
creature_ratios,creature_variety
)
obstacle_spawn_params=generate_spawn_params(
obstacle_ratios,obstacle_variety
)
resource_spawn_params=generate_spawn_params(
resource_ratios,resource_variety
)
at_title_screen=false
playing=true
end
end
local function mine_resources(player)
local resource,res_hitbox,mining_hitbox
if player.is_drilling() or player.is_mining() then
mining_hitbox=player.get_mining_hitbox()
for i=resources.get_resources().size(),1,-1 do
resource=resources.get_resources().get(i)
res_hitbox=resources.get_hitbox(resource)
if are_colliding(res_hitbox,mining_hitbox) then
local res_type=resource.res_type
if res_type=="red_sugar" then
player.give_health(1)
resources.get_resources().deletei(i)
elseif res_type=="nitra" then
player.give_ammo(.5)
resources.get_resources().deletei(i)
elseif res_type=="gold" then
player.give_points(100)
resources.get_resources().deletei(i)
elseif res_type=="class" then
player.change_role(resource.value)
elseif res_type=="number" then
game_logic.set_difficulty(resource.value)
end
sfx(-1,3)
sfx(38,3)
end
end
end
end
local function damage_creatures()
local creature_box,bullet_box,melee_box
local creatures_list=creatures.creatures_list
local bullets=projectiles.bullets_list
local creature,bullet,player_damage
for i=1,creatures_list.size() do
creature=creatures_list.get(i)
creature_box=get_hitbox(creature)
for j=bullets.size(),1,-1 do
bullet=bullets.get(j)
bullet_box=projectiles.get_bullet_hitbox(bullet)
if are_colliding(bullet_box, creature_box) then
creature.damage(bullet.damage,bullet.owner)
if not bullet.piercing then
bullets.deletei(j)
end
end
end
for player in all(players) do
if player.is_drilling() then
melee_box=player.get_damaging_hitbox()
player_damage=player.drills_damage
elseif player.is_mining() then
melee_box=player.get_damaging_hitbox()
player_damage=player.mining_damage
else
melee_box={x={3,4},y={3,4}}
player_damage=0
end
if are_colliding(creature_box,melee_box) then
creature.damage(player_damage,player)
end
end
end
end
local function damage_player(player)
local player_box,spit_box,creature_box
local spit,creature,spits
player_box=player.get_hitbox()
spits=projectiles.spits_list
for i=spits.size(),1,-1 do
spit=spits.get(i)
spit_box=projectiles.get_spit_hitbox(spit)
if are_colliding(player_box,spit_box) then
player.damage(spit.damage)
if not spit.persists then
spits.deletei(i)
end
end
end
for i=creatures.creatures_list.size(),1,-1 do
creature=creatures.creatures_list.get(i)
creature_box=creatures.get_hitbox(creature)
if are_colliding(player_box,creature_box) then
if creature.creature_damage>0 then
player.damage(creature.creature_damage)
end
end
end
end
local function update()
for player in all(players) do
mine_resources(player)
damage_player(player)
end
damage_creatures()
if timer%100==0 then
creature_spawn_rate+=.01
obstacle_spawn_rate+=.01
end
if playing then
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
for player in all(players) do
if player.health()<=0 then
playing=false
at_death_screen=true
end
end
timer+=1
end
local function obstacle_spawn_params_f() return obstacle_spawn_params end
local function resource_spawn_params_f() return resource_spawn_params end
local function creature_spawn_params_f() return creature_spawn_params end
return {
update=update,
set_difficulty=set_difficulty,
obstacle_spawn_params=obstacle_spawn_params_f,
resource_spawn_params=resource_spawn_params_f,
creature_spawn_params=creature_spawn_params_f,
}
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
draw_prog_bar(player.ammo()/player.max_ammo(),x+9,192)
if player.get_role()=="driller" then
spr(47,x,200)
draw_prog_bar(player.fuel()/player.max_fuel(),x+9,202)
end
spr(62,x,210)
print(player.points(),x+10,211,7)
end
return {
draw=draw,
}
end
function _init()
coop=true
player_1=new_player(1,"driller")
player_2=new_player(2,"gunner")
players={player_1}
if coop then add(players,player_2) end
projectiles=new_projectiles()
resources=new_resources()
creatures=new_creatures()
map=new_map()
hud=new_hud()
title_screen=new_title_screen()
death_screen=new_death_screen()
game_logic=new_game_logic()
performance_monitor=new_performance_monitor()
at_title_screen=true
playing=false
at_death_screen=false
end
function _update()
performance_monitor.reset_cpu_load()
if not at_death_screen then
projectiles.update()
resources.update()
map.update()
player_1.update()
if coop then player_2.update() end
creatures.update()
game_logic.update()
end
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
map.draw_vines()
map.draw_super_wall()
hud.draw(player_1)
if coop then hud.draw(player_2) end
if at_death_screen then
cls(1)
map.draw_wall()
map.draw_super_wall()
death_screen.draw()
end
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
local decision=pick_spawn(game_logic.obstacle_spawn_params())
if decision=="small" then
sprites={68,69,70,71,84,85,86,87,100,101,116,117}
size=1
else
sprites={72,74,102,104,106}
size=2
end
sprite=choose_one(sprites)
obstacles.add({
sprite=sprite,
x=x,
y=y,
size=size,
x_flip=coinflip(),
y_flip=coinflip(),
})
end
local function update()
local wall,terrain_piece
if playing then
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
for i=drilled_ground.size(),1,-1 do
drilled_ground.get(i).y+=1
if drilled_ground.get(i).y>=230 then
drilled_ground.deletei(i)
end
end
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
local cpu_percentage=0
local max_cpu_percentage=0
local min_fps=60
function reset_cpu_load()
cpu_percentage=0
end
function register_load()
cpu_percentage+=stat(1)
max_cpu_percentage=max(cpu_percentage, max_cpu_percentage)
end
function print_summary()
info = flr(max_cpu_percentage*100)/100
print("cpu spike: "..info, 150, 200)
print("fps low:   "..min_fps)
end
function print_current()
print(stat(7),218,103,11)
min_fps=min(stat(7),min_fps)
end
return {
register_load=register_load,
print_summary=print_summary,
print_current=print_current,
reset_cpu_load=reset_cpu_load,
}
end
function new_player(number,role)
local x=140+8*number
local y=200
local frame=0
local number=number
local role=role
local is={
moving={up,down,left,right},
shooting=false,
drilling=false,
mining=false,
rns=false}
local was_mining=false
local drills_damage=4
local mining_damage=10
local playing_sound_of={drill=false,gun=false}
local points=0
local max_ammo=role=="gunner" and 100 or 25
local ammo=max_ammo
local max_fuel=role=="driller" and 250 or 0
local fuel=max_fuel
local health=3
local max_health=3
local mining_since=60
local mining_delay=10
local hit_since=60
local shot_since=60
local shot_delay=role=="gunner" and 1 or 3
local collision_points={left={},right={},top={}}
local has_collision={left=false,right=false,top=false}
for i=1,8 do
add(collision_points.left,{x=0,y=0})
add(collision_points.right,{x=0,y=0})
add(collision_points.top,{x=0,y=0})
end
local function fetch_inputs()
local p=number-1
is.shooting=btn(5,p) and not btn(4,p)
if role=="gunner" and is.shooting then
is.moving.up=false
is.moving.left=false
is.moving.right=false
is.moving.down=true
else
is.moving.up=btn(2,p)
is.moving.down=btn(3,p)
is.moving.left=btn(0,p)
is.moving.right=btn(1,p)
end
is.rns=btn(3,p) and btn(4,p) and btn(5,p)
if btn(4,p) and not btn(5,p) then
is.drilling=fuel>0
is.mining=not is.drilling
else
is.drilling=false
is.mining=false
end
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
if mining_since>mining_delay then
map.spawn_drilled_ground(53,x,y-2)
sfx(-1,number)
sfx(31,number)
mining_since=0
end
end
local function drill()
if fuel>0 then
map.spawn_drilled_ground(52,x,y-2)
fuel-=1
if not playing_sound_of.drill then
sfx(-1,number)
sfx(30,number)
playing_sound_of.drill=true
end
end
end
local function shoot()
if shot_since>shot_delay then
if ammo>0 then
projectiles.fire_bullet(number)
ammo-=1
if role=="gunner" and not playing_sound_of.gun then
sfx(-1,number)
sfx(36,number)
playing_sound_of.gun=true
elseif role=="driller" or role=="engineer" then
sfx(-1,number)
sfx(34,number)
end
else
sfx(-1,number)
sfx(35,number)
end
shot_since=0
end
end
local function give_ammo(percentage)
ammo=min(ammo+max_ammo*percentage,max_ammo)
fuel=min(fuel+max_fuel*percentage,max_fuel)
end
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
elseif playing_sound_of.drill then
sfx(-1,number)
playing_sound_of.drill=false
end
if is.mining then mine() end
if is.shooting then
shoot()
elseif playing_sound_of.gun then
sfx(-1,number)
playing_sound_of.gun=false
end
mining_since+=1
shot_since+=1
hit_since+=1
frame+=1
end
local function damage_player(amount)
if hit_since>30 then
health-=amount
sfx(32)
hit_since=0
end
end
local function draw_gun()
pset(x+6,y,6)
pset(x+6,y+1,6)
if role=="gunner" then
pset(x+5,y,6)
pset(x+7,y,6)
pset(x+7,y+1,6)
pset(x+7,y+2,6)
pset(x+7,y+3,6)
pset(x+7,y+4,6)
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
local function change_role(new_role)
role=new_role
max_ammo=role=="gunner" and 100 or 25
ammo=max_ammo
max_fuel=role=="driller" and 250 or 0
fuel=max_fuel
shot_delay=role=="gunner" and 1 or 3
end
local function draw()
local moving,x_flip
local speed=1
if playing then
moving=(not is.moving.down
or is.moving.left or is.moving.right)
if playing and is.moving.up then speed=2 end
elseif at_title_screen then
moving=(is.moving.down or is.moving.up
or is.moving.left or is.moving.right)
end
local sprite=role=="driller" and 48 or 32
if role=="engineer" then sprite=34 end
if moving then sprite+=1 end
x_flip=frame>=8
frame=(frame+speed)%16
if hit_since<=30 then
pal(10,2)
pal(3,2)
pal(8,2)
end
spr(sprite,x,y,1,1,x_flip,false)
pal()
if is.shooting then draw_gun() end
if is.drilling then draw_drills() end
if mining_since<mining_delay*.7 then draw_pickaxe() end
end
return {
update=update,
draw=draw,
damage=damage_player,
give_ammo=give_ammo,
change_role=change_role,
give_points=function(amount) points+=amount end,
give_health=function(amount) health=min(health+amount,max_health) end,
get_hitbox=function() return {x={x+1,x+6},y={y,y+7}} end,
get_mining_hitbox=function() return {x={x,x+7},y={y-1,y+3}} end,
get_damaging_hitbox=function() return {x={x,x+7},y={y-3,y+3}} end,
x=function() return x end,
y=function() return y end,
is_drilling=function() return is.drilling end,
is_shooting=function() return is.shooting end,
is_mining=function() return mining_since<2 end,
get_role=function() return role end,
is_rns=function() return is.rns end,
health=function() return health end,
number=function() return number end,
ammo=function() return ammo end,
fuel=function() return fuel end,
points=function() return points end,
max_ammo=function() return max_ammo end,
max_fuel=function() return max_fuel end,
drills_damage=drills_damage,
mining_damage=mining_damage,
}
end
function new_projectiles()
local bullets=new_entity_container()
local spits=new_entity_container()
local menace_spits=new_entity_container()
local function fire_bullet(number)
local player=number==1 and players[1] or players[2]
bullets.add({
x=player.x(),
y=(player.y())-8,
owner=player,
damage=player.get_role()=="gunner" and 5 or 10,
piercing=player.get_role()=="gunner",
})
end
local function new_spit(spit_type,x,y)
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
sprite=28
speed=2
size=1
hitbox={x={5,5},y={6,8}}
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
local function spit_spit(spit_type,x,y)
spits.add(new_spit(spit_type,x,y))
end
local function add_menace_spit(x,y,x_vel,y_vel)
menace_spits.add({x=x,y=y,x_vel=x_vel,y_vel=y_vel})
end
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
local spit
for i=menace_spits.size(),1,-1 do
spit=menace_spits.get(i)
spit.x+=spit.x_vel
spit.y+=spit.y_vel
if spit.x<99 or spit.x>230 or spit.y<99 or spit.y>230 then
menace_spits.deletei(i)
end
end
end
local function draw()
for i=1,bullets.size() do
spr(29,bullets.get(i).x, bullets.get(i).y)
end
for i=1,spits.size() do
spits.get(i).draw()
end
local x,y
for i=1,menace_spits.size() do
x=flr(menace_spits.get(i).x)
y=flr(menace_spits.get(i).y)
pset(x,y,12)
end
end
local function get_bullet_hitbox(bullet)
return {
x={bullet.x+6,bullet.x+6},
y={bullet.y+5,bullet.y+15},
}
end
local function get_spit_hitbox(spit)
local x1=spit.hitbox.x[1]+spit.x()-1
local x2=spit.hitbox.x[2]+spit.x()-1
local y1=spit.hitbox.y[1]+spit.y()-1
local y2=spit.hitbox.y[2]+spit.y()-1
return {x={x1,x2}, y={y1,y2}}
end
local function get_menace_spit_hitbox(spit)
return {x={flr(spit.x),flr(spit.x)},y={flr(spit.y),flr(spit.y)}}
end
return {
update=update,
draw=draw,
fire_bullet=fire_bullet,
spit_spit=spit_spit,
add_menace_spit=add_menace_spit,
spits_list=spits,
bullets_list=bullets,
get_bullet_hitbox=get_bullet_hitbox,
get_spit_hitbox=get_spit_hitbox,
get_menace_spit_hitbox=get_menace_spit_hitbox,
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
local sprite,hitbox,start_sprite
local res_type=pick_spawn(game_logic.resource_spawn_params())
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
list.add({
sprite=sprite,
x=x,
y=y,
x_flip=coinflip(),
y_flip=coinflip(),
hitbox=hitbox,
res_type=res_type,
})
end
local function spawn_menu_item(x,y,sprite,type,value)
list.add({
sprite=sprite,
x=x,
y=y,
x_flip=false,
y_flip=type=="class",
hitbox=type=="class" and {x={2,7},y={2,7}} or {x={2,8},y={1,8}},
res_type=type,
value=value
})
end
local function update()
if playing then
for i=list.size(),1,-1 do
list.get(i).y+=1
if list.get(i).y>=230 then
list.deletei(i)
end
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
spawn=spawn_resource,
spawn_menu_item=spawn_menu_item,
}
end
function new_title_screen()
local res_list=resources.get_resources()
local x0=120
local y0=160
res_list.add(resources.spawn_menu_item(x0,y0,48,"class","driller"))
res_list.add(resources.spawn_menu_item(x0+15,y0,32,"class","gunner"))
res_list.add(resources.spawn_menu_item(x0+30,y0,34,"class","engineer"))
x0=170
y0=170
res_list.add(resources.spawn_menu_item(x0,y0,192,"number",1))
res_list.add(resources.spawn_menu_item(x0+8,y0,193,"number",2))
res_list.add(resources.spawn_menu_item(x0+16,y0,194,"number",3))
res_list.add(resources.spawn_menu_item(x0+24,y0,195,"number",4))
res_list.add(resources.spawn_menu_item(x0+32,y0,196,"number",5))
x0=160
y0=200
map.add_obstacle({
sprite=227,
x=x0,
y=y0,
size=2,
x_flip=false,
y_flip=false,
})
map.add_obstacle({
sprite=229,
x=x0+16,
y=y0,
size=2,
x_flip=false,
y_flip=false,
})
x0=105
y0=105
map.add_obstacle({
sprite=199,
x=x0,
y=y0,
size=4,
x_flip=false,
y_flip=false,
})
map.add_obstacle({
sprite=203,
x=x0+32,
y=y0,
size=4,
x_flip=false,
y_flip=false,
})
map.add_obstacle({
sprite=207,
x=x0+64,
y=y0,
size=1,
x_flip=false,
y_flip=false,
})
map.add_obstacle({
sprite=223,
x=x0+64,
y=y0+8,
size=1,
x_flip=false,
y_flip=false,
})
map.add_obstacle({
sprite=239,
x=x0+64,
y=y0+16,
size=1,
x_flip=false,
y_flip=false,
})
map.add_obstacle({
sprite=255,
x=x0+64,
y=y0+24,
size=1,
x_flip=false,
y_flip=false,
})
end
function are_colliding(a, b)
local x_good = a.x[1]>b.x[2] or a.x[2]<b.x[1]
local y_good = a.y[1]>b.y[2] or a.y[2]<b.y[1]
return not(x_good or y_good)
end
function coinflip() return rnd(2)<1 end
function sample_one(first,last) return first+flr(rnd(last+1)) end
function choose_one(list) return list[flr(rnd(#list))+1] end
function pick_spawn(spawn_params)
local decision=rnd(spawn_params.cum_sum)
for i=1,spawn_params.variety do
if decision<spawn_params.ratios[i][1] then
return spawn_params.ratios[i][2]
else
decision-=spawn_params.ratios[i][1]
end
end
end
function generate_spawn_params(ratios,variety)
local sum=0
for i=1,variety do
sum+=ratios[i][1]
end
local new_ratios={}
new_ratios.ratios=ratios
new_ratios.cum_sum=sum
new_ratios.variety=variety
print(new_ratios)
return new_ratios
end
