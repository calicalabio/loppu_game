extends Weapon

class_name SawBladeBase

func _init() -> void:
	name = "Saw Blade"
	code_name = "sawblade"
	path = "res://scenes/weapons/SawBlade.tscn"
	timer_name = "SawBladeTimer"
	description = "Spinning blade that returns to you"
	icon = load("res://assets/img/skills/skill_sawblade.png")
	frame = load("res://assets/img/skills/skill_01.png")
	next_frame = load("res://assets/img/skills/skill_02.png")
	is_equipped = false
		
	base_min_damage = 7.0
	base_max_damage = 10.0
	base_crit_rate = 5.0
	base_crit_damage = 100.0
	base_cooldown = 7.0
	base_projectile_speed = 200.0
	base_projectile_count = 1
	base_fire_rate = 0.7	
	
	upgrades = {
		1 : { 
			"damage" : [4.0, 9.0]
		},
		2 : {
			"damage" : [12.0, 15.0],
			"projectile_count" : 2	
		},
		3 : {
			"damage" : [18.0, 20.0]
		},
		4 : {
			"damage" : [18.0, 20.0],
			"projectile_count" : 3
		},
		5 : {
			"damage" : [25.0, 28.0]			
		},
		6 : {
			"damage" : [25.0, 28.0],
			"projectile_count" : 4	
		},
		7 : {
			"damage" : [30.0, 35.0]
		},
		8 : {
			"damage" : [30.0, 35.0],
			"projectile_count" : 5		
		}
	}
	
#	damage_level = 1
#
#	damage_levels = {
#		1 : [7.0, 10.0],
#		2 : [12.0, 15.0],
#		3 : [18.0, 20.0]
#	}
#
#	possible_stat_upgrades = {
#		"damage" : 10.0, 
#		"crit_rate" : 15.0,
#		"projectile_count" : 1
#	}	
#
#	stat_caps = {
#		"damage" : 80,
#		"crit_rate" : 65.0,
#		"projectile_count" : 4
#	}
	
	initialise_stats()
