extends Weapon

class_name ShortSwordBase

func _init() -> void:
	name = "Short Sword"
	code_name = "short_sword"
	path = "res://scenes/weapons/ShortSword.tscn"
	timer_name = "ShortSwordTimer"
	description = "Swords starting weapon"
	icon = load("res://assets/img/skills/skill_impale.png")
	frame = load("res://assets/img/skills/skill_01.png")
	next_frame = load("res://assets/img/skills/skill_02.png")
	is_class_weapon = true
	is_equipped = false
	
	damage_type = "physical"
	
	base_min_damage = 8.0
	base_max_damage = 16.0
	base_damage = 10.0
	base_crit_rate = 15.0
	base_crit_damage = 100.0
	base_cooldown = 1.5
	base_projectile_count = 1
	base_fire_rate = 0.3

	upgrades = {}
	
	initialise_stats()
