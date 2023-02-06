extends Weapon

class_name BoomerangBase

func _init() -> void:
	name = "Boomerang"
	code_name = "boomerang"
	path = "res://scenes/weapons/Boomerang.tscn"
	timer_name = "BoomerangTimer"
	description = "Spirals outwards while striking enemies"
	icon = load("res://assets/img/skills/skill_boomerang.png")
	frame = load("res://assets/img/skills/skill_01.png")
	next_frame = load("res://assets/img/skills/skill_02.png")
	is_equipped = false

	base_min_damage = 2.0
	base_max_damage = 3.0
	base_crit_rate = 1.0
	base_crit_damage = 100.0
	base_cooldown = 6.0
	base_projectile_speed = 8.0
	base_projectile_count = 1
	base_fire_rate = 0.4
	base_duration = 3.0
	
	knockback_strength = 0.5
	
	upgrades = {
		1 : { 
			"damage" : [3.0, 5.0],
			"duration" : 4.0
		},
		2 : {
			"damage" : [4.0, 7.0],
			"duration" : 5.0
		},
		3 : {
			"damage" : [5.0, 9.0],			
			"projectile_count" : 2
		},
		4 : {
			"damage" : [6.0, 11.0],
			"duration" : 6.0
		},
		5 : {
			"damage" : [7.0, 13.0],
			"duration" : 7.0			
		},
		6 : {
			"damage" : [8.0, 15.0],
			"projectile_count" : 3			
		},
		7 : {
			"damage" : [9.0, 17.0],			
			"duration" : 8.0
		},
		8 : {
			"damage" : [10.0, 19.0],
			"projectile_count" : 4	
		}
	}
	
#	damage_level = 1
#
#	damage_levels = {
#		1 : [2.0, 3.0],
#		2 : [3.0, 5.0],
#		3 : [4.0, 7.0],
#		4 : [5.0, 9.0],
#		5 : [6.0, 11.0],
#		6 : [7.0, 13.0],
#		7 : [8.0, 15.0]
#	}
	
#	possible_stat_upgrades = {
#		"damage" : 3.0,  		
#		"projectile_count" : 1,
#		"duration" : 1.0,
#	}
#
#	stat_caps = {
#		"damage" : 15.0,
#		"projectile_count" : 5,
#		"duration" : 7.0
#	}
	
	initialise_stats()
