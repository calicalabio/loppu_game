class_name EquipmentService 

var short_sword = "res://scripts/equipment/definitions/ShortSwordDefinition.gd"

var wooden_shield = "res://scripts/equipment/definitions/WoodenShieldDefinition.gd"

var skull_cap = "res://scripts/equipment/definitions/SkullCapDefinition.gd"
var witch_hat = "res://scripts/equipment/definitions/WitchHatDefinition.gd"
var kitsune_mask = "res://scripts/equipment/definitions/KitsuneMaskDefinition.gd"

var platemail = "res://scripts/equipment/definitions/PlatemailDefinition.gd"

var all_equipment : Array = [
	short_sword,
	wooden_shield,
	skull_cap,
	witch_hat,
	kitsune_mask,
	platemail
]


func generate_equipment_default(path : String) -> Equipment:
	var equipment = load(path).new()
	equipment.roll_default_stats()
	return equipment
	

func generate_random_equipment(amount_to_generate : int) -> Array:
	var equipment_list = []
	
	while equipment_list.size() < amount_to_generate:
		var equipment_path = all_equipment[Global.rng.randi_range(0, all_equipment.size() - 1)]
		var equipment = load(equipment_path).new()
		equipment.roll_stats()
		equipment_list.append(equipment)
	
	return equipment_list
