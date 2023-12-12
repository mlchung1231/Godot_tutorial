extends CanvasLayer

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

signal pause
signal back_to_game
signal button_position
signal reset_player

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
	

func _on_menu_button_pressed():
	$Menu.show()
	$Menu_button.hide()
	$game_button.hide()
	emit_signal("pause")
	emit_signal("button_position",$game_button/Joystick.position, $game_button/Attack_button.position, $game_button/Build_button.position)

func _on_menu_close_menu():
	$Menu.hide()
	$Menu_button.show()
	$game_button.show()
	emit_signal("back_to_game")


func _on_menu_button_move(joystick, attack, build):
	$game_button/Joystick.set_position(Vector2(joystick[0], joystick[1]))
	$game_button/Joystick_mark.set_position(Vector2(joystick[0], joystick[1]))
	$game_button/Attack_button.set_position(Vector2(attack[0], attack[1]))
	$game_button/Build_button.set_position(Vector2(build[0], build[1]))

func _on_retry_pressed():
	emit_signal("reset_player")
	get_tree().reload_current_scene()

func _on_exit_pressed():
	emit_signal("reset_player")
	get_tree().reload_current_scene()

func _on_player_player_dead(time,mob):
	$Dead/Sprite2D/time/value.text = str(time/60) + " : " + str(time%60)
	$Dead/Sprite2D/enemy/value.text = str(mob)
