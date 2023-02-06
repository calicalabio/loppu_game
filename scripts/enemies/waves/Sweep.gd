extends "res://scripts/enemies/waves/Pattern.gd"

onready var base_node = $Swarm
var flip_options = [-1, 1]


func initialise_swarm(target_position : Vector2):
	set_random_base_node_position(target_position)


func set_random_base_node_position(target_position : Vector2):	
	var x_coord = target_position.x - 350
	var y_coord = target_position.y
	
	self.global_position = Vector2(x_coord, y_coord)
