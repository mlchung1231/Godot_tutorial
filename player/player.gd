extends CharacterBody2D

@export var speed: int = 35
@onready var animations = $AnimationPlayer

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

func _on_auto_attack_body_entered(body):
	if body.is_in_group("mob"):
		attack_able_mob.push_back(body)
