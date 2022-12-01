extends AnimatedSprite2D

@onready var p = get_parent()
var objectif

func dirchange(dir):
	if dir == 1 and scale.y == -1:
		scale.y = 1
		rotation -= PI
	elif dir == -1 and scale.y == 1:
		scale.y = -1
		rotation += PI

func _ready():
	pass

func _process(delta):
	objectif = (1-scale.y)*90 + (p.vitesse_x/p.max_speed) * 5
	rotation += deg_to_rad((objectif - rad_to_deg(rotation))/8)
	position.x = p.get_node("Node2D").position.x * 0.8
