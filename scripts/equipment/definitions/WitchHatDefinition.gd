extends Equipment

class_name WitchHatDefinition


func _init() -> void:
	name = "Witch Hat"
	type = "helmet"
	icon = load("res://assets/img/equipment/witch_hat.png")
	potential_stats = ["health", "damage_reduction"]
	
	min_health = 5
	max_health = 15
	
	min_damage_reduction = 5
	max_damage_reduction = 10
