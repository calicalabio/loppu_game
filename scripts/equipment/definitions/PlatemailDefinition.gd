extends Equipment

class_name PlatemailDefinition


func _init() -> void:
	name = "Platemail"
	type = "chest"
	icon = load("res://assets/img/equipment/platemail.png")
	potential_stats = ["health", "damage_reduction"]
	
	min_health = 20
	max_health = 50
	
	min_damage_reduction = 10
	max_damage_reduction = 25
