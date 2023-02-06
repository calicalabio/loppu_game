extends Weapon

class_name BinglingBase

func _init() -> void:
	name = "Bingling"
	code_name = "bingling"
	path = "res://scenes/weapons/Bingling.tscn"
	timer_name = "BinglingTimer"
	description = "Rolls towards enemies and explodes"
	icon = load("res://assets/img/skills/skill_bingling.png")
	frame = load("res://assets/img/skills/skill_01.png")
	next_frame = load("res://assets/img/skills/skill_02.png")
	is_equipped = false

	base_min_damage = 20.0
	base_max_damage = 20.0
	base_crit_rate = 0.0
	base_crit_damage = 0.0
	base_cooldown = 12.0
	base_projectile_speed = 0.7
	base_projectile_count = 3
	base_fire_rate = 0.2
	

	upgrades = {
		1 : { 
			"damage" : [30.0, 30.0],
		},
		2 : {
			"damage" : [40.0, 40.0],
			"projectile_speed" : 0.8
		},
		3 : {
			"damage" : [50.0, 50.0],
			"projectile_count" : 5
		},
		4 : {
			"damage" : [70.0, 70.0],
		},
		5 : {
			"damage" : [90.0, 90.0],
			"projectile_speed" : 0.9
		},
		6 : {
			"damage" : [110.0, 110.0],
			"projectile_count" : 7
		},
		7 : {
			"damage" : [130.0, 130.0],
			"projectile_speed" : 1.0
		},
		8 : {
			"damage" : [150.0, 150.0],
			"projectile_count" : 10
		}
	}

#	damage_level = 1
#
#	damage_levels = {
#		1 : [15.0, 15.0],
#		2 : [25.0, 25.0],
#		3 : [45.0, 45.0]
#	}
#
#	possible_stat_upgrades = {
#		"damage" : 15.0, 
#		"projectile_count" : 1,
#		"projectile_speed" : 0.1
#	}
#
#	stat_caps = {
#		"damage" : 75.0,
#		"projectile_count" : 7,
#		"projectile_speed" : 1.0
#	}

	initialise_stats()
