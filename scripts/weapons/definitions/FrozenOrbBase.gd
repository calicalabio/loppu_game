extends Weapon

class_name FrozenOrbBase

func _init() -> void:
	name = "Frozen Orb"
	code_name = "frozen_orb"
	path = "res://scenes/weapons/FrozenOrb.tscn"
	timer_name = "FrozenOrbTimer"
	description = "slow moving and shoots icicles"	
	icon = load("res://assets/img/skills/skill_frozen_orb.png") 	
	frame = load("res://assets/img/skills/skill_01.png")
	next_frame = load("res://assets/img/skills/skill_02.png")
	is_equipped = false
	
	damage_type = "ice"
	
	base_min_damage = 5.0
	base_max_damage = 7.0
	base_crit_rate = 15.0
	base_crit_damage = 100.0
	base_cooldown = 12.0
	base_projectile_speed = 25.0
	base_projectile_count = 3
	base_penetration = 1
	base_duration = 3.0
	base_fire_rate = 0.2
	
	knockback_strength = 0.3
	
	upgrades = {
		1 : { 
			"damage" : [5.0, 7.0],
			"projectile_count" : 6
		},
		2 : {
			"damage" : [8.0, 10.0],			
			"duration" : 5.0
		},
		3 : {
			"damage" : [11.0, 13.0],
			"projectile_count" : 9
		},
		4 : {
			"damage" : [14.0, 16.0],
			"duration" : 7.0
		},
		5 : {
			"damage" : [17.0, 19.0],
			"projectile_count" : 12
		},
		6 : {
			"damage" : [20.0, 20.0],
			"penetration" : 2
		},
		7 : {
			"damage" : [20.0, 20.0],
			"projectile_count" : 15	
		},
		8 : {
			"damage" : [20.0, 20.0],
			"projectile_count" : 20
		}
	}
	
#	damage_level = 1
#
#	damage_levels = {
#		1 : [5.0, 10.0],
#		2 : [8.0, 15.0],
#		3 : [11.0, 20.0],
#		4 : [16.0, 25.0],
#		5 : [22.0, 32.0],
#		6 : [30.0, 38.0],
#		7 : [35.0, 45.0],
#		8 : [38.0, 55.0]
#	}
#
#	possible_stat_upgrades = {
#		"damage" : 0.0, 
#		"crit_rate" : 10.0,
#		"projectile_count" : 3,
#		"duration" : 1.0,
#		"penetration" : 1
#	}
#
#	stat_caps = {
#		"crit_rate" : 65.0,
#		"projectile_count" : 18,
#		"duration" : 7.0,
#		"penetration" : 5
#	}
	
	initialise_stats()
