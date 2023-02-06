extends Equipment

class_name SkullCapDefinition


func _init() -> void:
	name = "Skull Cap"
	type = "helmet"
	icon = load("res://assets/img/equipment/skull_cap.png")
	potential_stats = ["health", "damage_reduction"]
	
	min_health = 5
	max_health = 15
	default_health = 5
	
	min_damage_reduction = 5
	max_damage_reduction = 10
	default_damage_reduction = 5
