extends Node

var node_creation_parent = null

var time =  0
var mob_dead = 0
var bullet_direction = Vector2.ZERO

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func instance_node(node, location):
	var node_instance = node.instantiate()
	add_child(node_instance)
	node_instance.global_position = location
	return node_instance
