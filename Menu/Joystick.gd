extends Sprite2D

var player = preload("res://player/player.tscn")
var player_data = player.instantiate()
var joystick_position = player_data.joystick_position

var newDeltaX
var newDeltaY
var deltaX
var deltaY
var touchPos = Vector2()
var areaEnt = false
 
func _ready():
	set_position(Vector2(joystick_position[0],joystick_position[1]))
	

func _on_touch_screen_button_pressed():
	areaEnt = true

func _on_touch_screen_button_released():
	areaEnt = false
	
func _input(event):
	if areaEnt == true:
		if event is InputEventScreenTouch and event.is_pressed():
			touchPos = event.get_position()
			deltaX = touchPos.x - position.x
			deltaY = touchPos.y - position.y
			
		elif  event is InputEventScreenDrag:
			touchPos = event.get_position()
			if touchPos.x < get_viewport_rect().size.x / 2:
				newDeltaX = touchPos.x - deltaX
				newDeltaY = touchPos.y - deltaY
				set_position(Vector2(newDeltaX, newDeltaY))
				joystick_position[0] = newDeltaX
				joystick_position[1] = newDeltaY
			else:
				newDeltaY = touchPos.y - deltaY
				set_position(Vector2(newDeltaX, newDeltaY))
				joystick_position[1] = newDeltaY
				
