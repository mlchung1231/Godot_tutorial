extends Area2D


@export var speed : int = 300

var velocity = Vector2.ZERO
var look_once = true

func _ready():
	pass
	
func _physics_process(delta):
	if look_once:
		velocity = Global.bullet_direction
		look_once = false
	global_position += velocity * delta * speed
		
func _on_timer_timeout():
	queue_free()


