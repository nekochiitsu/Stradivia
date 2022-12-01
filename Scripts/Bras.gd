extends AnimatedSprite2D

@onready var p = get_parent().get_parent()

var waitingInput = 0
var countFrame = 0
var anims:Dictionary = {
	"pistol melee" : [0, 1, 2, 3],
	"pistol shoot" : [0, 1, 2, 3, 4],
	"shotgun melee" : [0, 1, 1, 1, 2, 3, 4, 5, 5, 6],
	"shotgun reload" : [0, 1, 1, 1, 2, 3, 4, 4, 4],
	"shotgun shoot" : [0, 1, 1, 2, 2, 3, 4],
	"sniper melee" : [0, 1, 1, 1, 1, 1, 1, 1, 1, 2, 2, 3, 3, 3],
	"sniper shoot" : [0, 0, 0, 0, 1, 2, 3, 3, 4, 4],
	"sword parry" : [0, 1, 2],
	"sword hit" : [0, 1, 2, 3],
	"sword estoc" : [0, 0, 0, 0, 0, 0, 0, 0, 1, 2, 3, 3, 4, 4],
}

func _ready():
	pass

func anim(delta):
	if p.hitting:
		frame = anims[animation][floor(countFrame)]
		if animation == "sniper melee":
			if !(Input.is_action_pressed("move 3") and int(countFrame) == 8):
				countFrame += delta*24
		elif animation == "sword estoc":
			if !(Input.is_action_pressed("move 2") and int(countFrame) == 4):
				countFrame += delta*24
		elif animation == "sniper shoot":
			if !(Input.is_action_pressed("move 1") and int(countFrame) == 3):
				countFrame += delta*24
		elif animation == "shotgun shoot":
			if int(countFrame) == 2:
				p.vitesse_x = -p.max_speed
			countFrame += delta*24
		else:
			countFrame += delta*24
		
		if frame == p.hitting-1:
			p.hitting = 0
		return
	if p.current_weapon == "none":
		animation = "default"
	elif p.current_weapon == "pistol":
		animation = "pistol idle"
	elif p.current_weapon == "shotgun":
		animation = "shotgun idle"
	elif p.current_weapon == "sniper":
		animation = "sniper idle"
	elif p.current_weapon == "sword":
		animation = "sword idle"

func hitbox(_delta):
	pass

func _process(delta):
	anim(delta)
	hitbox(delta)
	if Input.is_key_pressed(KEY_W):
		rotation = deg_to_rad(-20)
	elif Input.is_key_pressed(KEY_S):
		rotation = deg_to_rad(20)
	else:
		rotation = deg_to_rad(0)
	if waitingInput > 0:
		waitingInput -= delta
		if Input.is_action_just_pressed("switch_weapon"):
			p.current_weapon = "sword"
			animation = "sword parry"
			p.hitting = 3
			countFrame = 0
			waitingInput = 0
		elif Input.is_action_just_pressed("move 1"):
			p.current_weapon = "shotgun"
			animation = "shotgun melee"
			p.hitting = 7
			countFrame = 0
			waitingInput = 0
		elif Input.is_action_just_pressed("move 2"):
			p.current_weapon = "pistol"
			animation = "pistol melee"
			p.hitting = 4
			countFrame = 0
			waitingInput = 0
		elif Input.is_action_just_pressed("move 3"):
			p.current_weapon = "sniper"
			animation = "sniper melee"
			p.hitting = 4
			countFrame = 0
			waitingInput = 0
	if p.hitting == 0:
		if Input.is_action_just_pressed("switch_weapon"):
			p.game.freeze = 0.1
			waitingInput = 0.3
		
		elif p.current_weapon == "pistol":
			if Input.is_action_just_pressed("move 1"):
				animation = "pistol shoot"
				p.hitting = 4
				countFrame = 0
			elif Input.is_action_just_pressed("move 2"):
				pass
		
		elif p.current_weapon == "shotgun":
			if Input.is_action_just_pressed("move 1"):
				animation = "shotgun shoot"
				p.hitting = 5
				countFrame = 0
			elif Input.is_action_just_pressed("move 2"):
				animation = "shotgun reload"
				p.hitting = 5
				countFrame = 0
		elif p.current_weapon == "sniper":
			if Input.is_action_just_pressed("move 1"):
				animation = "sniper shoot"
				p.hitting = 5
				countFrame = 0
			elif Input.is_action_just_pressed("move 2"):
				pass
		
		elif p.current_weapon == "sword":
			if Input.is_action_just_pressed("move 1"):
				animation = "sword hit"
				p.hitting = 4
				countFrame = 0
			elif Input.is_action_just_pressed("move 2"):
				animation = "sword estoc"
				p.hitting = 5
				countFrame = 0
	
		if Input.is_action_just_pressed("unequip"):
			p.current_weapon = "none"
