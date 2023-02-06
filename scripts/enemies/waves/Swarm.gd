extends "res://scripts/enemies/waves/Pattern.gd"

onready var base_node = $Swarm
var flip_options = [-1, 1]


func initialise_swarm(target_position : Vector2):
	set_random_base_node_position(target_position)


func set_random_base_node_position(target_position : Vector2):
	var x_flip = flip_options[Global.rng.randi_range(0, 1)]
	var y_flip = flip_options[Global.rng.randi_range(0, 1)]
	
	var x_coord = target_position.x + (500 * x_flip)
	var y_coord = target_position.y + (250 * y_flip)	
	
	self.global_position = Vector2(x_coord, y_coord)
