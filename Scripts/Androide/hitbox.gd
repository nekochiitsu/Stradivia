extends Area2D

@onready var a = get_parent()
@onready var player = $"../../.."
@onready var hit_particule = load("res://Scenes/hit_particle.tscn")

var damage = 0
var angle = 0
var knockback = 0
var hitstun = 0
var duration = 0
var waitingInput = 0
var countFrame = 0
var prop:Dictionary = {
	"pistol melee" : [0, 0, 0, 0],
	"pistol shoot" : [0, 0, 0, 0, 0],
	"shotgun melee" : [0, 0, 0, 0, 0, 0, 0, 0, 0, 0],
	"shotgun reload" : [0, 0, 0, 0, 0, 0, 0, 0, 0],
	"shotgun shoot" : [0, 0, 0, 0, 0, 0, 0],
	"sniper melee" : [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0],
	"sniper shoot" : [0, 0, 0, 0, 0, 0, 0, 0, 0, 0],
	"sword parry" : [[10,-4,6,18,0, 0,0,2, 0.1,0.2], 0, 0],
	"sword hit" : [0, [13,2,8,34,0, 10,25,1, 0.2,0.032], 0, 0],
	"sword estoc" : [0, 0, 0, 0, 0, 0, 0, 0, [12,0,1,40,PI/2, 30,10,1.3, 0.3,0.032], 0, 0, 0, 0, 0],
}

func _ready():
	pass

func hitbox(delta):
	if a.p.hitting and prop[a.animation][floor(a.countFrame)]:
		var move = prop[a.animation][floor(a.countFrame)]
		$CollisionShape2d.position = Vector2(move[0], move[1])
		$CollisionShape2d.shape.radius = move[2]
		$CollisionShape2d.shape.height = move[3]
		$CollisionShape2d.rotation = move[4]
		damage = move[5]
		angle = move[6] - rad_to_deg(a.rotation)
		knockback = move[7]
		hitstun = move[8]
		duration = move[9]
		show()
	if duration > 0:
		duration -= delta
		var area = get_overlapping_areas()
		for i in area:
			var e = i.get_parent()
			if e.intangibility <= 0:
				e.hit(delta, self)
				var part = hit_particule.instantiate()
				part.position = Vector2(e.global_position.x, e.global_position.y )
				part.emitting = true
				part.amount = 6 + int(damage/8)
				part.direction = knockback*(e.hp/4+10)*Vector2(cos(deg_to_rad(angle))*(sign(e.global_position.x-player.global_position.x)), -sin(deg_to_rad(angle)))
				part.initial_velocity_min = knockback*(e.hp/4+10)*10
				part.initial_velocity_max *= 1.5
				player.game.add_child(part)
	else:
		hide()

func _process(delta):
	hitbox(delta)

