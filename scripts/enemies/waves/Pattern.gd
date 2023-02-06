extends Node2D


func get_enemy_spawn_points(pattern_name : String):
	var position_nodes = get_tree().get_nodes_in_group(pattern_name)
	var spawn_points : Array = []
		
	for pos in position_nodes:
		spawn_points.append(pos.global_position)
		
	return spawn_points
