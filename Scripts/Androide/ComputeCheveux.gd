extends Node2D

@onready var p = get_parent()
@onready var pos = p.get_node("Node2D").get_node("Cheveux")
var bp = Vector2(0, 0)


#(offx, offy), maxdist, (posx, posy), radius
var points = [
	[Vector2(0, 0), 0.5, Vector2(0, 0), 2],
	[Vector2(-1, 0), 1, Vector2(0, 0), 1],
	[Vector2(-1, 1), 1, Vector2(0, 0), 1]
]

func _ready():
	for i in range(10):
		points.append([Vector2(0, 1), 1, Vector2(0, 0), 1])

func _process(delta):
	for i in range(len(points)-1, -1, -1):
		if i == 0:
			points[i][2] = pos.global_position
			continue
		points[i][2] = points[i][0] + points[i-1][2]
		#points[i][2] = (points[i][0] + points[i][2] + points[i-1][2])/2
	for i in range(len(points)):
		if i == 0:
			continue
		if points[i][2].distance_to(points[i][0]+points[i-1][2]) > points[i][1]:
			var dir = (points[i-1][2]+points[i][0]).direction_to(points[i][2])
			var offset = dir * points[i][1]
			points[i][2] = points[i-1][2] + offset# + points[i][0]
	queue_redraw()

func _draw():
	for point in points:
		draw_circle((-bp + point[2] - p.position), point[3], Color.BLACK)













