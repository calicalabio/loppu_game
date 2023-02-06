extends Weapon

class_name MeteorBase

func _init() -> void:
	name = "Meteor"
	code_name = "meteor"
	path = "res://scenes/weapons/Meteor.tscn"
	timer_name = "MeteorTimer"
	description = "Drops meteors around you"
	icon = load("res://assets/img/skill_meteor.png")
	frame = load("res://assets/img/skills/skill_01.png")
	next_frame = load("res://assets/img/skills/skill_02.png")
	is_equipped = false	
	
	damage_type = "fire"
	
	base_min_damage = 1.0
	base_max_damage = 1.0
	base_crit_rate = 5.0
	base_crit_damage = 100.0
	base_cooldown = 8.0
	base_projectile_speed = 0.5
	base_projectile_count = 1
	base_fire_rate = 0.35
	
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
#		1 : [1.0, 5.0],
#		2 : [5.0, 10.0]
#	}
#
#	possible_stat_upgrades = {
#		"damage" : 200.0, 
#		"crit_rate" : 5.0,
#		"crit_damage" : 100.0,
#		"cooldown" : 10.0, 
#		"projectile_count" : 1
#	}
#
#	stat_caps = {
#		"crit_rate" : 100.0
#	}

	initialise_stats()
