extends "res://scripts/weapons/Turret.gd"

signal spawn_extra_hydra(disposable_timer, spawn_location, is_child, hydra_z_index)
signal ready_to_fire(hydra)
signal firebolt_ready(shot_direction, spawn_position)

onready var shot_delay_timer = $ShotDelayTimer

#var rng = RandomNumberGenerator.new()
var shot_direction : Vector2 = Vector2.ZERO


func initialise_hydra(weapon_data : Weapon, spawn_position : Vector2, is_parent : bool, hydra_z_index : int):
	initialise_turret(weapon_data, true)
	
	if not is_parent:
		self.global_position = spawn_position
#		self.z_index = hydra_z_index
	else:
		set_random_spawn_position(spawn_position)
#		self.z_index = convert_negative_z_index_to_positive(int(self.global_position.y))
		
		if weapon_data.summon_count > 1:
			var child_spawn_location = self.global_position
			var child_spawn_radius = Vector2(0, -15)
			var step = 2 * PI / weapon_data.summon_count

			for i in range(weapon_data.summon_count - 1):
				var next_spawn_position = child_spawn_location + child_spawn_radius.rotated(step * i)
				var hydra_spawn_timer = Timer.new()
				hydra_spawn_timer.one_shot = true
				hydra_spawn_timer.set_wait_time(float(1 + i) * 0.25)
				hydra_spawn_timer.connect("timeout", self, "trigger_extra_summon", [hydra_spawn_timer, next_spawn_position, convert_negative_z_index_to_positive(int(next_spawn_position.y))])
				add_child(hydra_spawn_timer)
				hydra_spawn_timer.start()
							

func convert_negative_z_index_to_positive(index : int) -> int:
	if index >= 0:
		return index
	else:
		return -1 * (100000 / index)		


func set_random_spawn_position(spawn_position : Vector2):
#	rng.randomize()
	
	var x_side = Global.rng.randi_range(0, 1)
	var y_side = Global.rng.randi_range(0, 1)
	
	if x_side == 0:
		self.global_position.x = spawn_position.x + 15
	else:
		self.global_position.x = spawn_position.x - 15

	if y_side == 0:
		self.global_position.y = spawn_position.y + 15
	else:
		self.global_position.y = spawn_position.y - 15

		
func trigger_extra_summon(disposable_timer : Timer, spawn_location : Vector2, hydra_z_index : int):
	emit_signal("spawn_extra_hydra", disposable_timer, spawn_location, true, hydra_z_index)


func trigger_attack():
	if turret_data.projectile_count > 1:
		for i in range(turret_data.projectile_count - 1):
			var extra_shot_timer = Timer.new()
			extra_shot_timer.one_shot = true
			extra_shot_timer.set_wait_time(0.3 * (i + 1))
			extra_shot_timer.connect("timeout", self, "emit_attack_signal")
			add_child(extra_shot_timer)
			extra_shot_timer.start()
	
	emit_attack_signal()	


func emit_attack_signal():
	emit_signal("ready_to_fire", self)


func start_attack_animation(nearest_enemy_direction : Vector2):
	if nearest_enemy_direction.y > 0:
		sprite.animation = "shoot_down"
	else:
		sprite.animation = "shoot_up"		

	if nearest_enemy_direction.x < 0:
		sprite.flip_h = false
	else:
		sprite.flip_h = true
	
	shot_direction = nearest_enemy_direction
	shot_delay_timer.start()


func _on_ShotDelayTimer_timeout() -> void:
	emit_signal("firebolt_ready", shot_direction, self.global_position)

