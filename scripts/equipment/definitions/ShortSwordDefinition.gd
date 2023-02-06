extends Equipment

class_name ShortSwordDefinition


func _init() -> void:
	name = "Short Sword"
	type = "weapon"
	icon = load("res://assets/img/equipment/short_sword.png")
	potential_stats = ["damage", "crit_rate", "crit_damage"]
	
	min_minimum_damage = 6
	max_minimum_damage = 12
	default_minimum_damage = 6
	
	min_maximum_damage = 14
	max_maximum_damage = 20
	default_maximum_damage = 14

	min_crit_rate = 5
	max_crit_rate = 20
	default_crit_rate = 5
	
	min_crit_damage = 50
	max_crit_damage = 100
	default_crit_damage = 50
	
