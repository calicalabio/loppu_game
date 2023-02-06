extends Weapon

class_name ChainLightningBase

func _init() -> void:
	name = "Chain Lightning"
	code_name = "chain_lightning"
	path = "res://scenes/weapons/ChainLightning.tscn"
	timer_name = "ChainLightningTimer"
	description = "Bounces lightning between foes"
	icon = load("res://assets/img/skills/skill_chain_lightning.png")
	frame = load("res://assets/img/skills/skill_01.png")
	next_frame = load("res://assets/img/skills/skill_02.png")
	is_equipped = false

	damage_type = "lightning"

	base_min_damage = 1.0
	base_max_damage = 5.0
	base_crit_rate = 15.0
	base_crit_damage = 100.0
	base_cooldown = 8.0
	base_projectile_count = 3
	base_fire_rate = 0.15
	base_summon_count = 1

	upgrades = {
		1 : { 
			"damage" : [1.0, 10.0],
			"projectile_count" : 6
		},
		2 : {
			"damage" : [1.0, 15.0],
			"projectile_count" : 9
		},
		3 : {
			"damage" : [1.0, 20.0],
			
		},
		4 : {
			"damage" : [1.0, 25.0]
		},
		5 : {
			"damage" : [1.0, 30.0],
			"summon_count" : 2
		},
		6 : {
			"damage" : [1.0, 35.0]			
		},
		7 : {
			"damage" : [1.0, 40.0],
			"projectile_count" : 12			
		},
		8 : {
			"damage" : [1.0, 45.0],
			"summon_count" : 3
		}
	}

#	damage_level = 1
#
#	damage_levels = {
#		1 : [1.0, 5.0],
#		2 : [1.0, 10.0],
#		3 : [1.0, 20.0],
#		4 : [1.0, 35.0],
#		5 : [1.0, 50.0],
#		6 : [1.0, 70.0]
#	}
	
#	possible_stat_upgrades = {
#		"damage" : 5.0, 
#		"crit_damage" : 100.0,
#		"projectile_count" : 1,
#		"summon_count" : 1
#	}
#
#	stat_caps = {
#		"damage" : 35.0,
#		"crit_damage" : 500.0,
#		"projectile_count" : 7,
#		"summon_count" : 5
#	}
	
	initialise_stats()
