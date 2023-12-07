extends Node2D
@onready var player = $".."
@onready var collisionShape = $"../CollisionShape2D"
# Called when the node enters the scene tree for the first time.
func _ready():
	#$bigger_Timer.start()
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if player.speed > 200:
		player.speed -= 0.3
	elif player.speed < 200:
		player.speed = 200
		
func effect_speedup():
	player.item_num += 1
	player.speed += 50

func effect_bigger():
	
	player.scale += Vector2(0.1,0.1)
	collisionShape.scale += Vector2(0.1,0.1)
	if !$bigger_Timer.is_stopped():
		$bigger_Timer.wait_time += 0.1
	$bigger_Timer.start()
	
func effect_get_sheild():
	if player.shield < 5:
		player.shield += 1
	if player.health < 100:
		player.health += 1
	
func _on_bigger_timer_timeout():
	collisionShape.scale = Vector2(1, 1)
	get_parent().scale = Vector2(1, 1)
