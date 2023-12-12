extends CharacterBody2D

@export var speed : float = 20 
@export var player : CharacterBody2D
@onready var nav_agent := $NavigationAgent2D as NavigationAgent2D

var health = 30
var dir = Vector2(1,0)
var face = [Vector2(1,0), Vector2(0,1), Vector2(-1,0), Vector2(0,-1),
			Vector2(1,1), Vector2(-1,1), Vector2(-1,-1), Vector2(1,-1)]
			
var attack_range = 100

var random_number = 0

func _ready():
	#makepath()
	pass

func _physics_process(delta) -> void:
	motion()
	velocity = dir * speed
	move_and_slide()
	#look_at(player.position)
	$Sprite2D.rotate(0.1)
	$HealthBar.value = health
	
func makepath():
	nav_agent.target_position = player.global_position

func _on_timer_timeout():	
	makepath()

func _on_tree_entered():
	global_position = Vector2(randi_range(-500, 500), randi_range(-500, 500))
	
		
func _on_area_2d_body_entered(body):
	if body.is_in_group("player"):
		Global.mob_dead += 1
		queue_free()
		
func _on_area_2d_area_entered(area):
	if area.is_in_group("bullet"):
		health -= 10
		modulate = Color.RED
		$Mob_stun.start()
		area.queue_free()
		if health <= 0:
			Global.mob_dead += 1
			queue_free()

func motion():
	#白天
	if Global.time % 40 < 20:
		dir = face[random_number].normalized()
		if global_position.distance_to(player.global_position) < attack_range:
			dir = to_local(nav_agent.get_next_path_position()).normalized()
	#夜晚
	else:
		dir = to_local(nav_agent.get_next_path_position()).normalized()

func _on_navigation_agent_2d_tree_entered():
	pass

func _on_mob_stun_timeout():
	modulate = Color.WHITE

func _on_turn_timeout():
	random_number = randi() % 8
	
	
