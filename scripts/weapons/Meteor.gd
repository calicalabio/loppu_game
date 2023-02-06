extends Area2D

signal clean_up(instance)

#var rng = RandomNumberGenerator.new()
var meteor : AnimatedSprite = null
var aoe : AnimatedSprite = null
var meteor_data : Weapon = null
#var meteor_speed : float = 0.0
#var damage : float = 0.0
#var min_damage : float = 0.0
#var max_damage : float = 0.0
#var crit_rate : float = 0.0
#var crit_damage : float = 0.0
#var can_knockback : bool = true


func _physics_process(delta: float) -> void:
	var direction_to_impact = meteor.global_position.direction_to(aoe.global_position)
	meteor.global_position += direction_to_impact * meteor_data.projectile_speed
	
	if meteor.global_position.y > (aoe.global_position.y - 20):
		deal_damage()


func initialise_meteor(weapon_data : Weapon, spawn_point : Vector2, target_location : Vector2):
#	rng.randomize()
	meteor = $MeteorSprite
	aoe = $AOE
	meteor_data = weapon_data
#	meteor_speed = weapon_data.projectile_speed
#	damage = weapon_data.damage
#	crit_rate = weapon_data.crit_rate
#	crit_damage = weapon_data.crit_damage
#	can_knockback = weapon_data.can_knockback
	self.global_position = target_location if not target_location == Vector2.ZERO else get_random_landing_spot(spawn_point)
	meteor.global_position = Vector2(self.global_position.x - 206.749, self.global_position.y - 382.705)
	

func deal_damage():
	for body in get_overlapping_bodies():
		if body.is_in_group("enemies") and not body.is_dying:
			body.take_damage(meteor_data)
		
	emit_signal("clean_up", self)	
	#queue_free()


func get_random_landing_spot(center_point : Vector2) -> Vector2:
	var random_angle = Global.rng.randf_range(-PI, PI)
	var direction = Vector2(cos(random_angle), sin(random_angle))
	var random_distance = 180 * sqrt(Global.rng.randf_range(0.0, 1.0))

	return (center_point + direction * random_distance).floor()
