extends ColorRect

@onready var p = get_parent().get_parent()
var hp_crit = 80.0

func _ready():
	pass

func _process(delta):
	size.x = 18*(1-exp(-p.hp/hp_crit))
	position.x = -size.x/2
	color = Color(0.5+0.5*exp(-p.hp/(hp_crit*2)), exp(-p.hp/hp_crit), exp(-p.hp/(hp_crit/2)))
