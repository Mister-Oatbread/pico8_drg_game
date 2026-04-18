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
damaged_since=min(damaged_since+1,1000)
frame=frame%60+1
end
local function damage(damage_received,player)
sfx(33,3)
damaged_since=0
health-=damage_received
if health<=0 then
alive=false
death_screen.report_killed_cave_angel()
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
damaged_since=min(damaged_since+1,1000)
frame=frame%10+1
end
local function damage(damage_received,player)
sfx(32,3)
health-=damage_received
damaged_since=0
if health<=0 then
player.give_ammo(.5)
player.give_health(1)
player.give_points(50)
death_screen.report_killed_egg()
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
sfx(33,3)
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
damaged_since=min(damaged_since+1,1000)
frame=frame%60+1
end
local function damage(damage_received,player)
sfx(33,3)
damaged_since=0
health-=damage_received
if health<=0 then
alive=false
player.give_ammo(.2)
death_screen.report_killed_loot_bug()
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
local function spawn_creature(x,y,type)
local x=x or sample_one(101,220)
local y=y or 81
local creature=type or pick_spawn(game_logic.creature_spawn_params())
if creature==menace then x=coinflip() and 104 or 216 end
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
spawn_creature=spawn_creature,
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
if playing then
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
sfx(46,3)
end
else
y+=1
if frame%2==0 then
y+=1
x-=sgn(x-tracked_player.x())
end
performing_spit=tracked_player.y()-y<30
end
end
damaged_since=min(damaged_since+1,1000)
frame=frame%16+1
end
local function damage(damage_received,player)
sfx(33,3)
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
if frame%10==0 then
local x_shot_position=x_flip and x+8 or x
local y_shot_position=y_flip and y+8 or y
local angle=atan2(
tracked_player.x()-x_shot_position+3,
tracked_player.y()-y_shot_position+3
)
local x_vel=2*cos(angle)
local y_vel=2*sin(angle)+1
sfx(46,3)
projectiles.add_menace_spit(
x_shot_position,
y_shot_position,
x_vel,
y_vel
)
end
frame=frame%10+1
damaged_since=min(damaged_since+1,1000)
end
local function damage(damage_received,player)
sfx(33,3)
damaged_since=0
health-=damage_received
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
sfx(47,3)
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
if not spitting then frame=frame%40+1 end
for player in all(players) do
if abs(x-player.x()-4)<20 and player.y()-y<20 then
if not spitting then
projectiles.spit_spit("praet_spit",x,y+16)
spitting=true
end
end
end
damaged_since=min(damaged_since+1,1000)
end
local function damage(damage_received,player)
sfx(33,3)
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
damaged_since=min(damaged_since+1,1000)
frame=frame%8+1
end
local function damage(damage_received,player)
sfx(33,3)
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
"steevie",
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
"nil",
"lisa",
"omega",
}
local killed_loot_bugs=new_entity_container()
local no_loot_bugs_killed=true
local no_cave_angels_killed=true
local no_eggs_killed=true
local points_total=0
local highscore=0
local death_screen_calculated=false
local function calculate_death_screen()
if not death_screen_calculated then
no_loot_bugs_killed=killed_loot_bugs.size()==0
for player in all(players) do
player.reposition(120+8*player.number()-1,193)
points_total+=player.points()
end
points_total+=game_logic.get_distance()
if no_loot_bugs_killed then points_total+=100 end
if no_cave_angels_killed then points_total+=100 end
if no_eggs_killed then points_total+=100 end
if at_title_screen then points_total+=500 end
local highscore_index=game_logic.hazard()
if coop then highscore_index+=5 end
highscore=dget(highscore_index)
if points_total>highscore then
dset(highscore_index,points_total)
end
end
death_screen_calculated=true
end
local function draw()
print("awards:", 111,126,7)
print("",113,126,7)
print("-distance bonus")
print(" (+"..game_logic.get_distance()..")")
if no_loot_bugs_killed then
print("-no loot_bugs")
print(" killed (+100)")
end
if no_cave_angels_killed then
print("-no cave angels")
print(" killed (+100)")
end
if no_eggs_killed then
print("-you spared the")
print(" scouts (+100)")
end
if at_title_screen then
print("-died during the")
print(" tutorial (+500)")
end
if not no_loot_bugs_killed then
print("killed",190,130,7)
print("loot")
print("bugs:")
local y = 148
for i=1,killed_loot_bugs.size() do
print(killed_loot_bugs.get(i),192,y)
y+=6
end
end
print("game over!",108,105)
print("score: "..points_total)
print("highscore: "..highscore)
local is_coop=coop and "coop" or ""
print("at hazard "..game_logic.hazard()..is_coop,158,105)
if points_total>highscore then
print("new highscore!!!")
end
end
local function report_killed_loot_bug()
killed_loot_bugs.add(loot_bug_names[sample_one(1,#loot_bug_names)])
end
return {
report_killed_loot_bug=report_killed_loot_bug,
report_killed_cave_angel=function() no_cave_angels_killed=false end,
report_killed_egg=function() no_eggs_killed=false end,
calculate_death_screen=calculate_death_screen,
draw=draw,
}
end
function new_entity_container()
local entities={}
return {
add=function(entity) add(entities,entity) end,
get=function(i) return entities[i] end,
delete=function(entity) del(entities,entity) end,
deletei=function(i) deli(entities,i) end,
size=function() return #entities end,
replace=function(i,new_entity) entities[i]=new_entity end,
}
end
function new_game_logic()
local obstacle_spawn_rate=.2
local obstacle_growth_rate=.03
local obstacle_variety=2
local obstacle_ratios={
{15,"small"},
{1,"big"},
}
local resource_spawn_rate=.01
local resource_growth_rate=0
local resource_variety=3
local resource_ratios={
{1,"gold"},
{1,"nitra"},
{1,"red_sugar"},
}
local creature_spawn_rate=.06
local creature_growth_rate=.02
local creature_variety=7
local creature_ratios={
{2,loot_bug},
{.01,egg},
{1,cave_angel},
{10,grunt},
{1,praetorian},
{2,slasher},
{1,mactera},
{.5,menace},
{1,oppressor},
}
local timer=0
local creature_spawn_params
local obstacle_spawn_params
local resource_spawn_params
local hazard=1
local function set_difficulty(difficulty)
if at_title_screen then
if difficulty==1 then
obstacle_spawn_rate=.08
resource_spawn_rate=.03
creature_spawn_rate=.04
obstacle_growth_rate=.02
creature_growth_rate=.01
creature_variety=4
elseif difficulty==2 then
creature_spawn_rate=.04
creature_growth_rate=.01
creature_variety=5
elseif difficulty==3 then
creature_variety=7
elseif difficulty==5 then
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
hazard=difficulty
dset(13,difficulty)
music(-1,0,0)
music(1,0,0)
end
end
local function mine_resources(player)
local resource,res_hitbox,mining_hitbox
if player.is_drilling() or player.is_mining() then
mining_hitbox=player.get_mining_hitbox()
for i=resources.get_resources.size(),1,-1 do
resource=resources.get_resources.get(i)
res_hitbox=resources.get_hitbox(resource)
if are_colliding(res_hitbox,mining_hitbox) then
local res_type=resource.res_type
if res_type=="red_sugar" then
player.give_health(1)
resources.get_resources.deletei(i)
elseif res_type=="nitra" then
player.give_ammo(.5)
resources.get_resources.deletei(i)
elseif res_type=="gold" then
player.give_points(100)
resources.get_resources.deletei(i)
elseif res_type=="class" then
player.change_role(resource.value)
elseif res_type=="number" then
set_difficulty(resource.value)
end
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
if hazard==1 and timer%128==0 then
for player in all(players) do
player.give_ammo(.1)
end
end
if playing then
if rnd()<creature_spawn_rate then
creatures.spawn_creature()
end
if rnd()<obstacle_spawn_rate then
map.spawn_obstacle()
end
if rnd()<resource_spawn_rate then
resources.spawn_resource()
end
timer+=1
if timer%640==0 then
creature_spawn_rate+=creature_growth_rate
obstacle_spawn_rate+=obstacle_growth_rate
resource_spawn_rate+=resource_growth_rate
end
end
for player in all(players) do
if player.health()<=0 then
playing=false
at_death_screen=true
end
end
end
return {
update=update,
set_difficulty=set_difficulty,
get_distance=function() return flr(timer/5) end,
obstacle_spawn_params=function() return obstacle_spawn_params end,
resource_spawn_params=function() return resource_spawn_params end,
creature_spawn_params=function() return creature_spawn_params end,
hazard=function() return hazard end,
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
local x=player.number()==1 and 105 or 202
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
music(-1,0,0)
music(56,0,0)
cartdata("oatbreadsdrillerdash")
coop=false
local roles={"driller","gunner","engineer"}
last_player_1_class=dget(11) and roles[dget(11)] or "driller"
last_player_2_class=dget(12) and roles[dget(12)] or "gunner"
player_1=new_player(1,last_player_1_class)
player_2=new_player(2,last_player_2_class)
players={player_1}
if coop then add(players,player_2) end
projectiles=new_projectiles()
resources=new_resources()
creatures=new_creatures()
map=new_map()
hud=new_hud()
props=new_props()
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
props.update()
game_logic.update()
else
death_screen.calculate_death_screen()
end
performance_monitor.register_load()
end
function _draw()
cls(1)
camera(101,101)
map.draw_terrain()
map.draw_wall()
map.draw_obstacles()
props.draw_props()
map.draw_drilled_ground()
resources.draw()
creatures.draw()
projectiles.draw()
if coop then player_2.draw() end
player_1.draw()
props.draw_particles()
map.draw_vines()
map.draw_super_wall()
hud.draw(player_1)
if coop then hud.draw(player_2) end
if at_death_screen then
cls(1)
map.draw_wall()
map.draw_super_wall()
if coop then player_2.draw() end
player_1.draw()
death_screen.draw()
performance_monitor.print_summary()
end
performance_monitor.register_load()
if playing then performance_monitor.print_current() end
end
function new_map()
local function add_wall(x,y)
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
walls.add(add_wall(x,y))
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
local function add_drilled_ground(sprite,x,y)
drilled_ground.add({sprite=sprite,x=x,y=y})
end
local function spawn_obstacle(sprite,x,y,size,x_flip,y_flip)
local sprites
size=size or pick_spawn(game_logic.obstacle_spawn_params())
if size==1 then
sprites={68,69,70,71,84,85,86,87,100,101,116,117}
else
sprites={72,74,102,104,106}
end
if x_flip==nil then x_flip=coinflip() end
if y_flip==nil then y_flip=coinflip() end
obstacles.add({
sprite=sprite or choose_one(sprites),
x=x or sample_one(101,220),
y=y or 81,
size=size,
x_flip=x_flip,
y_flip=y_flip,
})
end
local function update()
local wall,terrain_piece
if playing then
for i=1,walls.size() do
wall=walls.get(i)
wall.y+=1
if wall.y>=230 then
walls.replace(i,add_wall(wall.x,91))
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
add_drilled_ground=add_drilled_ground,
spawn_obstacle=spawn_obstacle,
poke_object=poke_obstacle,
}
end
function new_performance_monitor()
local cpu_percentage=0
local max_cpu_percentage=0
local min_fps=60
local function register_load()
cpu_percentage+=stat(1)
max_cpu_percentage=max(cpu_percentage, max_cpu_percentage)
end
local function print_summary()
local info = flr(max_cpu_percentage*100)/100
print("cpu spike: "..info, 107, 203)
print("fps low:   "..min_fps)
end
local function print_current()
print(stat(7),218,103,11)
min_fps=min(stat(7),min_fps)
end
return {
register_load=register_load,
print_summary=print_summary,
print_current=print_current,
reset_cpu_load=function() cpu_percentage=0 end,
}
end
function new_player(number,role)
local x=140+8*number
local y=205
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
map.add_drilled_ground(53,x,y-2)
sfx(-1,number)
sfx(31,number)
mining_since=0
end
end
local function drill()
if fuel>0 then
map.add_drilled_ground(52,x,y-2)
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
sfx(36,number)
playing_sound_of.gun=true
elseif role=="driller" or role=="engineer" then
sfx(34,number)
end
else
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
mining_since=min(mining_since+1,1000)
shot_since=min(shot_since+1,1000)
hit_since=min(hit_since+1,1000)
end
local function damage_player(amount)
if hit_since>30 then
health-=amount
sfx(32,number)
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
local role_ids={driller=1,gunner=2,engineer=3}
dset(10+number,role_ids[role])
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
reposition=function(x_new, y_new) x=x_new;y=y_new end,
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
return {
update=update,
draw=draw,
x=function() return x end,
y=function() return y end,
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
function new_props()
local props=new_entity_container()
local props_ratios={
{1,nectar_rind},
{1,orchey_shy},
{.1,p0q},
}
local prop_spawn_params=generate_spawn_params(
props_ratios,#props_ratios
)
local function spawn_prop()
local x=sample_one(101,220)
local y=81
local prop=pick_spawn(prop_spawn_params)
props.add(prop(x,y))
end
local function update()
if playing then
local prop
for i=props.size(),1,-1 do
prop=props.get(i)
prop.update()
if prop.y()>=240 then
props.deletei(i)
end
end
if rnd()<.02 then
spawn_prop()
end
end
end
function draw_props()
for i=1,props.size() do
props.get(i).draw()
end
end
function draw_particles()
for i=1,props.size() do
props.get(i).draw_particles()
end
end
return {
update=update,
draw_props=draw_props,
draw_particles=draw_particles,
}
end
function nectar_rind(x,y)
local x=x
local y=y
local x_flip = coinflip()
local y_flip = coinflip()
local function draw()
local sprite=172
for player in all(players) do
if ((player.x()-x)^2 + (player.y()-y)^2) < 30^2 then
sprite=173
end
end
spr(sprite,x,y,1,1,x_flip,y_flip)
end
return {
x=function() return x end,
y=function() return y end,
update=function() y+=1 end,
draw=draw,
draw_particles=function() end,
}
end
function orchey_shy(x, y)
local x=x
local y=y
local x_flip=coinflip()
local y_flip=coinflip()
local function draw()
local sprite
local distance=10000
for player in all(players) do
distance=min((player.x()-x)^2 + (player.y()-y)^2,distance)
end
sprite=188
if distance<225 then
sprite=190
elseif distance<900 then
sprite=189
end
spr(sprite,x,y,1,1,x_flip,y_flip)
end
return {
x=function() return x end,
y=function() return y end,
update=function() y+=1 end,
draw=draw,
draw_particles=function() end,
}
end
function p0q(x, y)
local x=x
local y=y
local x_flip=coinflip()
local y_flip=coinflip()
local particles=new_entity_container()
local n=20
local radius,angle_offset,is_blue
local angle=rnd()
for i=1,n do
angle_offset=i/n
radius=sample_one(3,12)
is_blue=rnd()<.9 and true or false
particles.add({
radius=radius,
angle_offset=angle_offset,
is_blue=is_blue,
})
end
function draw_particles()
local x_pos,y_pos
for i=1,n do
radius=particles.get(i).radius
angle_offset=particles.get(i).angle_offset
x_pos=ceil(radius*cos(angle+angle_offset))
y_pos=ceil(radius*sin(angle+angle_offset))
color=particles.get(i).is_blue and 12 or 7
if rnd()>.99 then
particles.get(i).is_blue=not particles.get(i).is_blue
end
pset(x_pos+x+8,y_pos+y+8,color)
end
end
return {
x=function() return x end,
y=function() return y end,
update=function() y+=1; angle=(angle+.003)%1 end,
draw=function() spr(140,x,y,2,2,x_flip,y_flip) end,
draw_particles=draw_particles,
}
end
function new_resources()
local list=new_entity_container()
local function spawn_resource(x,y,type)
local sprite,hitbox,start_sprite
local res_type=type or pick_spawn(game_logic.resource_spawn_params())
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
sprite=sprite or sample_one(start_sprite,start_sprite+3)
list.add({
sprite=sprite,
x=x or sample_one(101,220),
y=y or 81,
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
return {
update=update,
draw=draw,
get_hitbox=get_hitbox,
get_resources=list,
spawn_resource=spawn_resource,
spawn_menu_item=spawn_menu_item,
}
end
function new_title_screen()
local x0=170
local y0=140
resources.spawn_resource(x0,y0,"nitra")
resources.spawn_resource(x0-2,y0+20,"gold")
resources.spawn_resource(x0+14,y0+15,"red_sugar")
x0=180
y0=120
creatures.spawn_creature(120,150,loot_bug)
creatures.spawn_creature(130,150,cave_angel)
creatures.spawn_creature(x0,y0,grunt)
creatures.spawn_creature(x0+10,y0,slasher)
creatures.spawn_creature(x0+18,y0,praetorian)
creatures.spawn_creature(x0+34,y0,mactera)
x0=200
y0=160
map.spawn_obstacle(nil,x0,y0,2)
map.spawn_obstacle(nil,x0,y0-5,1)
x0=180
y0=180
resources.spawn_menu_item(x0,y0,48,"class","driller")
resources.spawn_menu_item(x0+15,y0,32,"class","gunner")
resources.spawn_menu_item(x0+30,y0,34,"class","engineer")
x0=118
y0=170
resources.spawn_menu_item(x0,y0,192,"number",1)
resources.spawn_menu_item(x0+15,y0,193,"number",2)
resources.spawn_menu_item(x0+30,y0,194,"number",3)
resources.spawn_menu_item(x0+45,y0,195,"number",4)
resources.spawn_menu_item(x0+60,y0,196,"number",5)
local last_diff=dget(13)
last_diff=last_diff==0 and 1 or last_diff
resources.spawn_menu_item(148,198,191+last_diff,"number",last_diff)
x0=190
y0=200
map.spawn_obstacle(227,x0,y0,2,false,false)
map.spawn_obstacle(229,x0+16,y0,2,false,false)
x0=105
y0=105
map.spawn_obstacle(199,x0,   y0,   4,false,false)
map.spawn_obstacle(203,x0+32,y0,   4,false,false)
map.spawn_obstacle(207,x0+64,y0,   1,false,false)
map.spawn_obstacle(223,x0+64,y0+8, 1,false,false)
map.spawn_obstacle(239,x0+64,y0+16,1,false,false)
map.spawn_obstacle(255,x0+64,y0+24,1,false,false)
map.spawn_obstacle(208,x0+10,y0+32,1,false,false)
map.spawn_obstacle(209,x0+18,y0+32,1,false,false)
map.spawn_obstacle(210,x0+26,y0+32,1,false,false)
map.spawn_obstacle(211,x0+34,y0+32,1,false,false)
map.spawn_obstacle(212,x0+42,y0+32,1,false,false)
end
function are_colliding(a, b)
local x_good = a.x[1]>b.x[2] or a.x[2]<b.x[1]
local y_good = a.y[1]>b.y[2] or a.y[2]<b.y[1]
return not(x_good or y_good)
end
function coinflip() return rnd(2)<1 end
function sample_one(first,last) return first+flr(rnd(last-first+1)) end
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
