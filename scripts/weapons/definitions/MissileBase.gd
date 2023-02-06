extends Weapon

class_name MissileBase

func _init() -> void:
	name = "Magic Missile"
	code_name = "missile"
	path = "res://scenes/weapons/Missile.tscn"
	timer_name = "MissileTimer"
	description = "fires in the direction you're facing"	
	icon = load("res://assets/img/skills/skill_magic_missile.png")	
	frame = load("res://assets/img/skills/skill_01.png")
	next_frame = load("res://assets/img/skills/skill_02.png")
	is_equipped = false
	
	base_min_damage = 3.0
	base_max_damage = 7.0
	base_crit_rate = 15.0
	base_crit_damage = 100.0
	base_cooldown = 3.5
	base_projectile_speed = 150.0
	base_projectile_count = 3
	base_penetration = 1
	base_duration = 3.0
	base_fire_rate = 0.2		
	
	can_stun = true
	base_stun_duration = 0.2
	
	upgrades = {
		1 : { 
			"damage" : [4.0, 9.0],
			"projectile_count" : 5
		},
		2 : {
			"damage" : [6.0, 11.0],
			"penetration" : 2
		},
		3 : {
			"damage" : [9.0, 13.0],
			"projectile_count" : 7
		},
		4 : {
			"damage" : [12.0, 15.0],
			"projectile_count" : 9
		},
		5 : {
			"damage" : [14.0, 18.0],
			"projectile_count" : 11
		},
		6 : {
			"damage" : [16.0, 20.0],
			"projectile_count" : 13
		},
		7 : {
			"damage" : [18.0, 23.0],
			"projectile_count" : 15
		},
		8 : {
			"damage" : [20.0, 25.0],
			"penetration" : 4
		}
	}
	
#	damage_level = 1
#
#	damage_levels = {
#		1 : [3.0, 7.0],
#		2 : [4.0, 9.0],
#		3 : [6.0, 11.0],
#		4 : [9.0, 13.0],
#		5 : [12.0, 15.0],
#		6 : [14.0, 18.0],
#		7 : [16.0, 23.0],
#		8 : [20.0, 25.0]
#	}
	
#	possible_stat_upgrades = {
#		"damage" : 5.0, 
#		"crit_rate" : 10.0,
#		"penetration" : 1, 
#		"projectile_count" : 2
#	}
#
#	stat_caps = {
#		"damage" : 50.0,
#		"crit_rate" : 65.0,
#		"penetration" : 5, 
#		"projectile_count" : 11
#	}
	
	initialise_stats()
