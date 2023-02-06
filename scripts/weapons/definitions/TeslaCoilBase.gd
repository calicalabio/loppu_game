extends Weapon

class_name TeslaCoilBase

func _init() -> void:
	name = "Tesla Coil"
	code_name = "tesla_coil"
	path = "res://scenes/weapons/TeslaCoil.tscn"
	timer_name = "TeslaCoilTimer"
	description = "Tower that zaps nearby enemies"	
	icon = load("res://assets/img/skills/skill_tesla_coil.png")
	frame = load("res://assets/img/skills/skill_01.png")
	next_frame = load("res://assets/img/skills/skill_02.png")
	is_equipped = false
			
	damage_type = "lightning"
			
	base_min_damage = 1.0
	base_max_damage = 5.0
	base_crit_rate = 5.0
	base_crit_damage = 100.0
	base_cooldown = 10.0
	base_projectile_count = 5
	base_duration = 6.0
	base_fire_rate = 0.9		
	
	knockback_strength = 0.6
	
	upgrades = {
		1 : { 
			"damage" : [1.0, 20.0],
			"projectile_count" : 8
		},
		2 : {
			"damage" : [1.0, 35.0],			
			"projectile_count" : 11
		},
		3 : {
			"damage" : [1.0, 50.0],
		},
		4 : {
			"damage" : [1.0, 65.0],
			"projectile_count" : 14
		},
		5 : {
			"damage" : [1.0, 80.0]
		},
		6 : {
			"damage" : [1.0, 95.0],
			"projectile_count" : 17
		},
		7 : {
			"damage" : [1.0, 110.0]	
		},
		8 : {
			"damage" : [1.0, 150.0],
			"projectile_count" : 20
		}
	}
	
#	damage_level = 1
#
#	damage_levels = {
#		1 : [1.0, 5.0],
#		2 : [1.0, 10.0],
#		3 : [1.0, 20.0],
#		4 : [1.0, 35.0],
#		5 : [1.0, 50.0]
#	}
#
#	possible_stat_upgrades = {
#		"damage" : 5.0, 
#		"duration" : 2.0,
#		"projectile_count" : 3,
#		"fire_rate" : 0.2,
#	}
#
#	stat_caps = {
#		"damage" : 35,
#		"duration" : 18.0,
#		"projectile_count" : 20,
#		"fire_rate" : 0.8
#	}
	
	initialise_stats()
