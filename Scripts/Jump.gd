extends AnimatedSprite2D

func _ready():
	frame = 0

func _process(_delta):
	if frame == 5:
		queue_free()
