extends CharacterBody2D

@onready var game = get_parent()
@onready var player = $"../Player"
@onready var jump_cloud = load("res://Scenes/Jump_cloud.tscn")
@onready var hit_particule = load("res://Scenes/AH.tscn")

var is_grapplin
var len_grapple
var max_speed
var jump_number
var jump_force
var vitesse_y
var vitesse_x
var accel
var grav
var fastfall
var was_on_floor
var hp = 0
var intangibility = 0
var in_hitstun = 0

var hitting 
var freeze

var current_weapon
var weapons

func not_greater_than(number, maxn):
	if (number > maxn):
		return (maxn)
	elif (number < -maxn):
		return (-maxn)
	else:
		return (number)

func jump(mult):
	was_on_floor = false
	vitesse_y = (grav/-5)*mult
	if Input.is_key_pressed(KEY_A) and !hitting:
		if vitesse_x > 0:
				vitesse_x = 0
	if Input.is_key_pressed(KEY_D) and !hitting:
		if vitesse_x < 0:
				vitesse_x = 0
	var jumpc = jump_cloud.instantiate()
	jumpc.position = Vector2(position.x, position.y + 0)
	game.add_child(jumpc)
	
func move(delta):
	set_velocity(Vector2(vitesse_x, vitesse_y)*10)
	move_and_slide()
	if is_on_floor():
		accel = max_speed/15
		vitesse_x += accel*(sign(player.global_position.x-global_position.x))
		if abs(vitesse_x) > max_speed:
			vitesse_x = sign(vitesse_x)*max_speed
		vitesse_y = 0
	else:
		accel = max_speed*10
		if in_hitstun > 0 and accel < not_greater_than((grav * abs(vitesse_y/20) + grav*0.2), grav):
			vitesse_y += delta * accel
		else:
			vitesse_y += delta * not_greater_than((grav * abs(vitesse_y/20) + grav*0.2), grav)
	var sign = vitesse_x
	vitesse_x += accel * -sign(vitesse_x) * delta
	if vitesse_x/sign < 0:
		vitesse_x = 0

func hit(delta, area):
	#game.freeze = 0.1 + area.damage/100
	in_hitstun = area.hitstun
	hp += area.damage
	var dist = (hp/4+10)*area.knockback
	vitesse_x += dist*cos(deg_to_rad(area.angle))*(sign(global_position.x-area.player.global_position.x))
	if sign(global_position.x-area.player.global_position.x) == -1:
		scale.y = -1
		rotation = PI
	else:
		scale.y = 1
		rotation = 0
	vitesse_y = -dist*sin(deg_to_rad(area.angle))
	var part = hit_particule.instantiate()
	part.position = Vector2(global_position.x, global_position.y-10)
	part.emitting = true
	part.scale.y = -scale.y
	part.rotation = rotation+PI
	get_parent().add_child(part)
	intangibility = 0.2

func _ready():
	vitesse_x = 0.
	vitesse_y = 0.
	jump_number = 0
	grav = 250
	fastfall = 1
	set_up_direction(Vector2(0, -1))
	max_speed = 4.
	freeze = 0
	hitting = 0
	was_on_floor = true	

func _process(delta):
	if game.freeze > 0:
		return
	move(delta)
	if intangibility > 0:
		intangibility -= delta
	$Sprite2d.animation = "default"
	if in_hitstun > 0:
		in_hitstun -= delta
		$Sprite2d.animation = "damages"

	if position.y > 100:
		hp = 0
		position = Vector2(-110, -21)


