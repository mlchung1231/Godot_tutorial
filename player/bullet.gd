extends Area2D


@export var speed : int = 300

var velocity = Vector2.ZERO

func _physics_process(delta):
	position += velocity * delta

# 设置子弹移动方向
func set_direction(direction):
	velocity = direction.normalized() * speed

func _on_body_entered(body):
	if body.is_in_group("mob"):
		body.queue_free()
		queue_free()

func _on_timer_timeout():
	queue_free()
