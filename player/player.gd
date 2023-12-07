extends CharacterBody2D

@export var speed: int = 35
@onready var animations = $AnimationPlayer

var bullet = preload("res://things/turret/bomb.tscn")

signal build_terret

var move_vector = Vector2(0,0)
var joystick_active = false

var is_dead = false

var item_num = 0
var shield = 0
var health = 100

var can_shoot = true
var is_shooting = false

var attack_able_mob = []

func handle_input():
#	var mone_direction = Input.get_vector("ui_left","ui_right","ui_up","ui_down")
#	velocity = mone_direction*speed
	
	if joystick_active:
		velocity = move_vector * speed
	else:
		velocity = Vector2(0,0) * speed
		$HUD/Joystick_mark.position = $HUD/Joystick.position
	
	if item_num < 5:
		$HUD/Build_button.modulate = Color.DIM_GRAY
	else:
		$HUD/Build_button.modulate = Color.WHITE
	
	if can_shoot and is_shooting:
		shoot()
		

func _input(event):
	if event is InputEventScreenTouch or event is InputEventScreenDrag:
		if $HUD/Joystick/Touch_area.is_pressed():
			move_vector = calculate_move_vector(event.position)
			joystick_active = true
			var joystick_range = event.position.distance_to($HUD/Joystick.position)
			if joystick_range > 15: 
				$HUD/Joystick_mark.position = calculate_move_vector(event.position) * 15 + $HUD/Joystick.position
			else:
				$HUD/Joystick_mark.position = event.position
			
	if event is InputEventScreenTouch:
		if event.pressed == false:
			joystick_active = false

func calculate_move_vector(event_position):
	return (event_position - $HUD/Joystick.position).normalized()	
			
func updatAnimation():
	
	if(velocity.length() == 0): 
		if(animations.is_playing()): animations.stop()
	else:
		var direction
		if abs(velocity.x) > abs(velocity.y):	
			if(velocity.x < 0): direction = "left"
			else: direction = "right"
		else:
			if(velocity.y < 0): direction = "up"
			else: direction = "down"
		animations.play("walk_" + direction)
	
func _physics_process(delta):
	handle_input()
	move_and_slide()
	updatAnimation()

func _on_attack_button_button_down():
	$HUD/Attack_button.modulate = Color.ORANGE
	is_shooting = true

func _on_attack_button_button_up():
	$HUD/Attack_button.modulate = Color.WHITE
	is_shooting = false

func _on_auto_attack_body_entered(body):
	if body.is_in_group("mob"):
		attack_able_mob.push_back(body)

func _on_auto_attack_body_exited(body):
	if body.is_in_group("mob"):
		attack_able_mob.erase(body)
	if body == bullet:
		body.queue_free()

func _on_build_button_pressed():
	emit_signal("build_terret")
	

func shoot():
	var projectile = bullet.instantiate()
	add_child(projectile)
		
	if !attack_able_mob.is_empty():
		var nearest_mob = attack_able_mob[0]
		for i in range(attack_able_mob.size()):
			if position.distance_to(attack_able_mob[i].position) < position.distance_to(nearest_mob.position):
				nearest_mob = attack_able_mob[i]
				
		look_at(nearest_mob.position)
		
	projectile.transform = $Marker2D.transform
	$Reload.start()
	can_shoot = false

func _on_reload_timeout():
	can_shoot = true
