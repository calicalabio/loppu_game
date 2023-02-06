extends "res://scripts/weapons/Projectile.gd"

signal fire_icicle(direction, spawn_point)

onready var sprite = $AnimatedSprite
onready var shot_timer = $ShotTimer

var frozen_orb_data : Weapon = null
var base_shot_direction : Vector2 = Vector2(1000, 0)
var shot_angle_interval : float = 0.0
var shots_fired : int = 0


func _process(delta: float) -> void:
	sprite.rotation += 1.0


func initialise_frozen_orb(weapon_data : Weapon, spawn_location : Vector2, travel_direction : Vector2):	
	frozen_orb_data = weapon_data
	shot_angle_interval = 360.0 / float(frozen_orb_data.projectile_count)
	shots_fired = 0
	initialise_projectile(travel_direction, weapon_data, spawn_location, null, true)
	set_shot_time()
	shot_timer.start()


func set_shot_time():
	if frozen_orb_data.projectile_count <= 3:
		shot_timer.wait_time = 0.2
	elif frozen_orb_data.projectile_count <= 6:
		shot_timer.wait_time = 0.15
	elif frozen_orb_data.projectile_count <= 9:
		shot_timer.wait_time = 0.1
	elif frozen_orb_data.projectile_count <= 12:
		shot_timer.wait_time = 0.05
	elif frozen_orb_data.projectile_count <= 15:
		shot_timer.wait_time = 0.03
	elif frozen_orb_data.projectile_count <= 18:
		shot_timer.wait_time = 0.02


func _on_ShotTimer_timeout() -> void:			
	emit_signal("fire_icicle", base_shot_direction.rotated(deg2rad(shot_angle_interval * shots_fired)), self.global_position)
	shots_fired += 1
