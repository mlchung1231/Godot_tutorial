extends Node2D

@export var crate_node : PackedScene
@export var mob_node : PackedScene
@export var turret : PackedScene

var player
# Called when the node enters the scene tree for the first time.
func _ready():
	for i in range(100):
		var crate = crate_node.instantiate()
		crate.init_crate()
		add_child(crate)
		player = $player

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	$CanvasLayer/HSplitContainer/Label.text = str(player.item_num)
	$CanvasLayer/HSplitContainer2/Label.text = str(player.health)
#	if Input.is_action_just_pressed("build"):
#		print(player.item_num)
#		if player.item_num >= 5:
#			var temp = turret.instantiate()
#			add_child(temp)
#			temp.position = player.global_position
#			player.item_num -= 5

func _on_mob_spawn_timer_timeout():
	var mob = mob_node.instantiate()
	mob.player = $player
	add_child(mob)


func _on_player_build_terret():
	if player.item_num >= 5:
			var temp = turret.instantiate()
			add_child(temp)
			temp.position = player.global_position
			player.item_num -= 5
