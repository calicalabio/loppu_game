extends Weapon

class_name DiscoBallBase

func _init() -> void:
	name = "Disco Ball"
	code_name = "disco_ball"
	path = "res://scenes/weapons/DiscoBall.tscn"
	description = "Zaps nearby enemies"
	icon = load("res://assets/img/skills/skill_disco_ball.png")
	frame = load("res://assets/img/skills/skill_01.png")
	next_frame = load("res://assets/img/skills/skill_02.png")
	is_equipped = false

	damage_type = "lightning"

	base_min_damage = 1.0
	base_max_damage = 1.0
	base_crit_rate = 10.0
	base_crit_damage = 100.0
	base_projectile_count = 2
	base_fire_rate = 0.3
	base_aoe = 80.0
	
	knockback_strength = 0.0
	
	upgrades = {
		1 : { 
			"damage" : [1.0, 1.0],
			"projectile_count" : 5
		},
		2 : {
			"damage" : [1.0, 2.0],			
			"crit_damage" : 200.0
		},
		3 : {
			"damage" : [1.0, 2.0],
			"projectile_count" : 7
		},
		4 : {
			"damage" : [1.0, 3.0],
		},
		5 : {
			"damage" : [1.0, 3.0],
			"projectile_count" : 9
		},
		6 : {
			"damage" : [1.0, 3.0],
			"crit_damage" : 300.0
		},
		7 : {
			"damage" : [1.0, 3.0]	,
			"crit_damage" : 400.0		
		},
		8 : {
			"damage" : [1.0, 4.0],
			"projectile_count" : 12
		}
	}

#	damage_level = 1
#
#	damage_levels = {
#		1 : [1.0, 1.0],
#		2 : [1.0, 2.0],
#		3 : [1.0, 4.0]
#	}
#
#	possible_stat_upgrades = { 
#		"crit_rate" : 5.0,
#		"crit_damage" : 100.0,
#		"projectile_count" : 2
#	}
#
#	stat_caps = {
#		"crit_rate" : 65.0,
#		"crit_damage" : 1000.0,
#		"projectile_count" : 30
#	}
	
	initialise_stats()
