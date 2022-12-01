extends Node2D

@onready var p = get_parent()
var offset
var objfY
var objfX

func _ready():
	offset = 2

func _process(_delta):
	objfX = -(p.vitesse_x/p.max_speed) * offset
	objfY = -(p.vitesse_y/p.grav) * offset
	position.x = (objfX - position.x)/8
	position.y = (objfY - position.y)/8
	
