extends Weapon

class_name ImpaleBase

func _init() -> void:
	name = "Impale"
	code_name = "impale"
	path = "res://scenes/weapons/Impale.tscn"
	timer_name = "ImpaleTimer"
	description = "Strikes and stuns nearby enemies"
	icon = load("res://assets/img/skills/skill_impale.png")
	frame = load("res://assets/img/skills/skill_01.png")
	next_frame = load("res://assets/img/skills/skill_02.png")
	is_equipped = false

	base_min_damage = 10.0
	base_max_damage = 11.0
	base_crit_rate = 50.0
	base_crit_damage = 100.0
	base_cooldown = 6.0
	base_projectile_count = 1
	base_fire_rate = 0.3
	
	can_stun = true
	base_stun_duration = 1.0

	upgrades = {
		1 : { 
			"damage" : [14.0, 15.0],
			"cooldown" : 5.0
		},
		2 : {
			"damage" : [18.0, 20.0],
			"stun_duration" : 2.0
		},
		3 : {
			"damage" : [25.0, 30.0],
			"stun_duration" : 3.0
		},
		4 : {
			"damage" : [40.0, 41.0],
			"cooldown" : 4.0
		},
		5 : {
			"damage" : [45.0, 46.0],
			"cooldown" : 3.0
		},
		6 : {
			"damage" : [50.0, 55.0],
			"stun_duration" : 3.0
		},
		7 : {
			"damage" : [60.0, 70.0],
			"cooldown" : 2.0
		},
		8 : {
			"damage" : [80.0, 90.0],
			"stun_duration" : 5.0
		}
	}

#	damage_level = 1
#
#	damage_levels = {
#		1 : [10.0, 11.0],
#		2 : [16.0, 20.0],
#		3 : [19.0, 25.0]
#	}
	
#	possible_stat_upgrades = {
#		"damage" : 10.0, 
#		"crit_damage" : 100.0,
#		"cooldown" : 1.0, 
#		"stun_duration" : 1.0
#	}
#
#	stat_caps = {
#		"damage" : 80.0,
#		"crit_damage" : 300.0,
#		"cooldown" : 4.0,
#		"stun_duration" : 5.0
#	}
	
	initialise_stats()
