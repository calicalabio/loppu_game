extends Equipment

class_name KitsuneMaskDefinition


func _init() -> void:
	name = "Kitsune Mask"
	type = "helmet"
	icon = load("res://assets/img/equipment/kitsune_mask.png")
	potential_stats = ["movespeed"]
	
	min_movespeed = 10
	max_movespeed = 35
