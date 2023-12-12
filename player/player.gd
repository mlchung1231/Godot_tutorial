extends CharacterBody2D

@export var speed: int = 35
@export var attack_position: Array = [200 ,85]
@export var build_position: Array = [160 ,85]
@export var joystick_position: Array = [45 ,95]

@onready var animations = $AnimationPlayer

var bullet = preload("res://player/bullet.tscn")

signal build_terret
signal player_dead

var move_vector = Vector2(0,0)
var joystick_active = false

var is_dead = false
var dead_moment = 0
var mob_kill = 0

var item_num = 0
var shield = 0
var health = 100

var can_shoot = true
var is_shooting = false

var attack_able_mob = []

var menu_show = false

var face = Vector2(1,0)

func _physics_process(delta):
	handle_input()
	move_and_slide()
	updatAnimation()
	$HUD/HealthBar.value = health
	$HUD/Shield/Label.text = str(shield)
	dead_and_statistics()

func handle_input():
	if joystick_active:
		velocity = move_vector * speed
		face = move_vector
	else:
		velocity = Vector2(0,0) * speed
		$HUD/game_button/Joystick_mark.position = $HUD/game_button/Joystick.position
	
	if item_num < 5:
		$HUD/game_button/Build_button.modulate = Color.DIM_GRAY
	else:
		$HUD/game_button/Build_button.modulate = Color.WHITE
	
	if can_shoot and is_shooting:
		shoot()

var left_hand_index = -1  
var right_hand_index = -1  

func _input(event):
	if !menu_show:
		if event is InputEventScreenTouch:
			if event.is_pressed():
				# 检查触摸位置以确定左右手
				if event.position.x < get_viewport_rect().size.x / 2:
					# 左手触摸事件
					left_hand_index = event.index
					handle_left_hand_touch(event.position)
				else:
					# 右手触摸事件
					right_hand_index = event.index
					# 右手逻辑（点击）...
					if $HUD/game_button/Attack_button.get_global_rect().has_point(event.position):
						$HUD/game_button/Attack_button.modulate = Color.ORANGE
						is_shooting = true
					
					if $HUD/game_button/Build_button.get_global_rect().has_point(event.position):
						emit_signal("build_terret")

			if event.is_pressed() == false:
				if event.index == left_hand_index:
					left_hand_index = -1
					joystick_active = false  # 左手触摸事件结束，禁用操控
					# 左手触摸事件结束
				elif event.index == right_hand_index:
					right_hand_index = -1
					$HUD/game_button/Attack_button.modulate = Color.WHITE
					is_shooting = false
					# 右手触摸事件结束

		if event is InputEventScreenDrag:
			if event.index == left_hand_index:
				handle_left_hand_touch(event.position)

func handle_left_hand_touch(touch_position):
	if $HUD/game_button/Joystick/Touch_area.is_pressed():
		move_vector = calculate_move_vector(touch_position)
		joystick_active = true
		var joystick_range = touch_position.distance_to($HUD/game_button/Joystick.position)
		if joystick_range > 15: 
			$HUD/game_button/Joystick_mark.position = calculate_move_vector(touch_position) * 15 + $HUD/game_button/Joystick.position
		else:
			$HUD/game_button/Joystick_mark.position = touch_position

func calculate_move_vector(event_position):
	return (event_position - $HUD/game_button/Joystick.position).normalized()	
			
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

func dead_and_statistics():
	if health <= 0:
		$HUD/Menu_button.hide()
		$HUD/Dead.show()
		menu_show = true
		joystick_active = false
		is_dead = true
	if !is_dead:
		dead_moment = Global.time
		mob_kill = Global.mob_dead
	else:
		emit_signal("player_dead",dead_moment,mob_kill)
	
func _on_area_2d_area_entered(area):
	if area.is_in_group("Enemy_damage"):
		health -= 10 - shield
		modulate = Color.RED
		$Stun.start()

func _on_stun_timeout():
	modulate = Color.WHITE

func _on_auto_attack_body_entered(body):
	if body.is_in_group("mob"):
		attack_able_mob.push_back(body)

func _on_auto_attack_body_exited(body):
	if body.is_in_group("mob"):
		attack_able_mob.erase(body)
	if body == bullet:
		body.queue_free()

func shoot():
	Global.instance_node(bullet, global_position)
		
	if !attack_able_mob.is_empty():
		var nearest_mob = attack_able_mob[0]
		for i in range(attack_able_mob.size()):
			if position.distance_to(attack_able_mob[i].position) < position.distance_to(nearest_mob.position):
				nearest_mob = attack_able_mob[i]
				
		Global.bullet_direction = (nearest_mob.global_position - global_position).normalized()
		
	else:
		Global.bullet_direction = face
	#projectile.transform = $Marker2D.transform
	$Reload.start()
	can_shoot = false

func _on_reload_timeout():
	can_shoot = true

func _on_hud_pause():
	menu_show = true
	
func _on_hud_back_to_game():
	menu_show = false

func _on_hud_reset_player():
	Global.time = 0
	Global.mob_dead = 0
