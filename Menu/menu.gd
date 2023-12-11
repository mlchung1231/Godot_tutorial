extends Control

signal close_menu
signal button_move

var master_bus = AudioServer.get_bus_index("Master")


func show_and_hide(first, second):
	first.show()
	second.hide()
	
	
func _on_back_from_option_pressed():
	emit_signal("close_menu")
	
func _on_music_pressed():
	show_and_hide($Music_page, $Options)

func _on_back_from_setting_pressed():
	show_and_hide($Options, $Music_page)


func _on_music_value_changed(value):
	AudioServer.set_bus_volume_db(master_bus, value)
	

func _on_adjustment_pressed():
	show_and_hide($Adjust_page, $Options)


func _on_back_from_adjust_pressed():
	emit_signal("button_move", $Adjust_page/Joystick.joystick_position, $Adjust_page/Attack.attack_position, $Adjust_page/Build.build_position,)
	show_and_hide($Options, $Adjust_page)
