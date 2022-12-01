extends CharacterBody2D

@onready var game = get_parent()
@onready var jump_cloud = load("res://Scenes/Jump_cloud.tscn")

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
var in_combat

var hitstun
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
		accel = max_speed*20
		vitesse_y = grav*delta
		#was_on_floor = true
		jump_number = 1
		fastfall = 1
		if Input.is_action_just_pressed("jump"):
			jump(1)
	else:
		#if was_on_floor:
		#	was_on_floor = false
		#	vitesse_y = 0
		accel = max_speed*10
		vitesse_y += delta * not_greater_than((grav * abs(vitesse_y/10) + (grav*0.2))*fastfall, grav*fastfall) 
		if Input.is_action_just_pressed("jump") and jump_number > 0:
			jump_number -= 1
			jump(1.2)
		if Input.is_action_just_pressed("fastfall") and fastfall == 1:
			fastfall = 2.5
	if hitting != 0:
		accel /= 4
	if Input.is_key_pressed(KEY_A) or Input.is_key_pressed(KEY_D):
		if Input.is_key_pressed(KEY_A):
			$Node2D.scale.y = -1
			$Node2D.rotation = PI
			$Body.dirchange(1-(2*in_combat))
			if vitesse_x > 0 and is_on_floor() and !hitting:
				vitesse_x = 0
			vitesse_x -= accel * delta
			if vitesse_x < -max_speed:
				vitesse_x += accel * delta
				if vitesse_x > -max_speed:
					vitesse_x = -max_speed
		if Input.is_key_pressed(KEY_D):
			$Node2D.scale.y = 1
			$Node2D.rotation = 0
			$Body.dirchange(-1+(2*in_combat))
			if vitesse_x < 0 and is_on_floor() and !hitting:
				vitesse_x = 0
			vitesse_x += accel * delta
			if vitesse_x > max_speed:
				vitesse_x -= accel * delta
				if vitesse_x < max_speed:
					vitesse_x = max_speed
	elif vitesse_x:
		var sign = vitesse_x
		vitesse_x += accel * -sign(vitesse_x) * delta
		if vitesse_x/sign < 0:
			vitesse_x = 0
	

func _ready():
	vitesse_x = 0
	vitesse_y = 0
	jump_number = 0
	grav = 250
	fastfall = 1
	set_up_direction(Vector2(0, -1))
	max_speed = 16
	freeze = 0
	hitstun = 0
	hitting = 0
	in_combat = 0
	was_on_floor = true
	current_weapon = "none"
	weapons = ["pistol", "sniper"]
	

func _process(delta):
	if game.freeze <= 0:
		move(delta)
	else:
		pass
	if position.y > 100:
		position = Vector2(-110, -21)
