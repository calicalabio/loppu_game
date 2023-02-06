extends Weapon

class_name HydraBase

func _init() -> void:
	name = "Hydra"
	code_name = "hydra"
	path = "res://scenes/weapons/Hydra.tscn"
	timer_name = "HydraTimer"
	description = "Worm friends"	
	icon = load("res://assets/img/skills/skill_hydra.png")
	frame = load("res://assets/img/skills/skill_01.png")
	next_frame = load("res://assets/img/skills/skill_02.png")
	is_equipped = false
			
	damage_type = "fire"			
			
	base_min_damage = 4.0
	base_max_damage = 10.0
	base_crit_rate = 5.0
	base_crit_damage = 100.0
	base_cooldown = 10.0
	base_projectile_speed = 300.0
	base_projectile_count = 1
	base_penetration = 1
	base_duration = 9.0
	base_fire_rate = 1.0		
	base_summon_count = 3
	
	upgrades = {
		1 : { 
			"damage" : [10.0, 14.0],
			"summon_count" : 4
		},
		2 : {
			"damage" : [16.0, 20.0]
		},
		3 : {
			"damage" : [22.0, 26.0],
			"summon_count" : 5
		},
		4 : {
			"damage" : [28.0, 32.0],
		},
		5 : {
			"damage" : [34.0, 38.0],
			"summon_count" : 6
		},
		6 : {
			"damage" : [42.0, 46.0]
		},
		7 : {
			"damage" : [48.0, 52.0]	,
			"summon_count" : 7	
		},
		8 : {
			"damage" : [54.0, 60.0],
			"summon_count" : 8
		}
	}
	
#	damage_level = 1
#
#	damage_levels = {
#		1 : [4.0, 6.0],
#		2 : [8.0, 10.0],
#		3 : [12.0 , 15.0]
#	}
#
#	possible_stat_upgrades = {
#		"damage" : 5.0, 
#		"duration" : 1.0,
#		"summon_count" : 1,
#		"fire_rate" : 0.325,
#	}
#
#	stat_caps = {
#		"damage" : 35,
#		"duration" : 13.0,
#		"summon_count" : 7,
#		"fire_rate" : 0.7
#	}
	
	initialise_stats()
