extends CanvasLayer

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

signal pause
signal back_to_game

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _on_menu_button_pressed():
	$Menu.show()
	$Menu_button.hide()
	$Joystick.hide()
	$Joystick_mark.hide()
	$Attack_button.hide()
	$Build_button.hide()
	emit_signal("pause")

func _on_menu_close_menu():
	$Menu.hide()
	$Menu_button.show()
	$Joystick.show()
	$Joystick_mark.show()
	$Attack_button.show()
	$Build_button.show()
	emit_signal("back_to_game")


func _on_menu_button_move(joystick, attack, build):
	$Joystick.set_position(Vector2(joystick[0], joystick[1]))
	$Joystick_mark.set_position(Vector2(joystick[0], joystick[1]))
	$Attack_button.set_position(Vector2(attack[0], attack[1]))
	$Build_button.set_position(Vector2(build[0], build[1]))

