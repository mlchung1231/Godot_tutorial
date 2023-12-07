extends CharacterBody2D

@export var speed : float = 20 
@export var player : CharacterBody2D
@onready var nav_agent := $NavigationAgent2D as NavigationAgent2D

func _ready():
	makepath()

func _physics_process(delta) -> void:
	var dir = to_local(nav_agent.get_next_path_position()).normalized()
	velocity = dir * speed
	move_and_slide()
	#look_at(player.position)
	$Sprite2D.rotate(0.1)
	
func makepath():
	nav_agent.target_position = player.global_position
	
func _on_timer_timeout():	
	makepath()

func _on_tree_entered():
	global_position = Vector2(randi_range(-500, 500), randi_range(-500, 500))
	
		
func _on_area_2d_body_entered(body):
	if body.is_in_group("player"):
		player.health -= 10 - player.shield
		queue_free()
		
func _on_navigation_agent_2d_tree_entered():
	pass
		



