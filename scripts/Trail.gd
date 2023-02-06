extends Line2D

var max_length : int = 200
var next_point : Vector2 = Vector2()

func _process(delta):
	var parent_node = get_parent()
	self.global_position = Vector2(0, 6)
	self.global_rotation = 0
	next_point = parent_node.global_position
	add_point(next_point)
	
	while get_point_count() > max_length:
		remove_point(0)
