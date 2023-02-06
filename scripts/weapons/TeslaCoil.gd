extends "res://scripts/weapons/Turret.gd"

signal tesla_ready_to_attack(instance)

onready var aoe = $AOE


func initialise_tesla_coil(weapon_data : Weapon, spawn_location : Vector2):
	initialise_turret(weapon_data, true)
	global_position = Vector2(spawn_location.x, spawn_location.y - 20)


func trigger_attack():
	sprite.animation = "fire"
	sprite.frame = 0
	sprite.play()


func prepare_zap():
	emit_signal("tesla_ready_to_attack", self)


func zap(lightning_instances : Array):
	var bodies = aoe.get_overlapping_bodies()
#	var zap_count = 0

#	if bodies.size() > 0:
#		for i in bodies.size():
#			if zap_count < turret_data.projectile_count:
#				if bodies[i].is_in_group("enemies") and not bodies[i].is_dying:
#					var lightning_instance = lightning_instances[i]
#					add_child(lightning_instance)
#					lightning_instance.initialise_lightning(Vector2(0, 0), bodies[i].global_position - global_position)
#					bodies[i].take_damage(turret_data.min_damage, turret_data.max_damage, turret_data.crit_rate, turret_data.crit_damage)
#					bodies[i].play_zap_effect()
#					zap_count += 1
	
	var zapped_enemies = []
				
	for lightning in lightning_instances:
		for body in bodies:
			if not zapped_enemies.has(body) and body.is_in_group("enemies") and not body.is_dying:
				zapped_enemies.append(body)
				add_child(lightning)
				lightning.initialise_lightning(Vector2(0, 0), body.global_position - global_position)
				body.take_damage(turret_data)
				
				body.play_zap_effect()	
				break


func clean_weapon_instance(lightning_instance : Node):
	emit_signal("clean_up", lightning_instance)


func _on_AnimatedSprite_frame_changed() -> void:
	if sprite.animation == "fire" and sprite.frame == 6:
		prepare_zap()
