extends "res://scripts/weapons/Turret.gd"

onready var sparkle_scene = preload("res://scenes/weapons/Sparkle.tscn")

onready var area = $AOE
onready var collision_shape = $AOE/CollisionShape2D

#var rng = RandomNumberGenerator.new()
var disco_data : Weapon = null
#var damage : float = 0.0
#var min_damage : float = 0.0
#var max_damage : float = 0.0
#var crit_rate : float = 0.0
#var crit_damage : float = 0.0
#var sparkles_per_attack : int = 0
#var aoe : float = 0.0
#var can_knockback : bool = false


func initialise_disco_ball(weapon_data : Weapon, spawn_position : Vector2):
	initialise_turret(weapon_data, false)
	disco_data = weapon_data
#	rng.randomize()
#	damage = weapon_data.damage
#	min_damage = weapon_data.min_damage
#	max_damage = weapon_data.max_damage
#	crit_rate = weapon_data.crit_rate
#	crit_damage = weapon_data.crit_damage
#	can_knockback = weapon_data.can_knockback
#	sparkles_per_attack = weapon_data.projectile_count
#	aoe = weapon_data.aoe
	collision_shape.shape.radius = weapon_data.aoe
	self.global_position = Vector2(spawn_position.x, spawn_position.y - 55)
	

func trigger_attack():
	var nearby_bodies = area.get_overlapping_bodies()
	var enemies = []

	for body in nearby_bodies:
		if body.is_in_group("enemies") and not body.is_dying:
			enemies.append(body)		

	if enemies.size() == 0:		
		sparkle(get_random_location_within_range())	
	else:
		var sparkle_count = 1
		
		while sparkle_count <= disco_data.projectile_count:
			var random_enemy_index : int = 100000
			
			while random_enemy_index > (enemies.size() - 1):
				random_enemy_index = Global.rng.randi_range(0, (nearby_bodies.size() - 1))	
			
			var enemy_to_attack = enemies[random_enemy_index]
			enemy_to_attack.take_damage(disco_data)
			
			sparkle(enemy_to_attack.global_position)
			sparkle_count += 1
		
		
func sparkle(sparkle_position : Vector2):
	var new_sparkle = sparkle_scene.instance()
	add_child(new_sparkle)
	new_sparkle.initialise_sparkle(sparkle_position)


func get_random_location_within_range() -> Vector2:
	var random_angle = Global.rng.randf_range(-PI, PI)
	var direction = Vector2(cos(random_angle), sin(random_angle))
	var random_distance = disco_data.aoe * sqrt(Global.rng.randf_range(0.0, 1.0))
	
	return (self.global_position + direction * random_distance).floor()


func update_stats(weapon_data : Weapon):
	disco_data = weapon_data
#	damage = weapon_data.damage
#	min_damage = weapon_data.min_damage
#	max_damage = weapon_data.max_damage
#	crit_rate = weapon_data.crit_rate
#	crit_damage = weapon_data.crit_damage
#	sparkles_per_attack = weapon_data.projectile_count
#	aoe = weapon_data.aoe
#	collision_shape.shape.radius = weapon_data.aoe
	initialise_turret(weapon_data, false)
