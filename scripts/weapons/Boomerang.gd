extends Node2D

signal clean_up(instance)

onready var body = $BoomerangBody
onready var expiry_timer = $ExpiryTimer

var boomerang_stats : Weapon = null
var current_angle = 0
var radius : float = 15.0
var radial_acceleration : float = 0.5


func initialise_boomerang(weapon_data : Weapon, spawn_coordinates : Vector2):
	current_angle = 0
	radius = 15.0
	self.global_position = spawn_coordinates
	body.global_position = self.global_position
	boomerang_stats = weapon_data
	expiry_timer.wait_time = boomerang_stats.duration
	expiry_timer.start()
	

func _physics_process(delta: float) -> void:
	current_angle += boomerang_stats.projectile_speed * delta
	var offset = Vector2(sin(current_angle), cos(current_angle)) * radius
	body.global_position = self.global_position + offset
	radius += radial_acceleration


func _on_BoomerangBody_body_entered(body: Node) -> void:
	if body.is_in_group("enemies") and not body.is_dying:
		body.take_damage(boomerang_stats)


func _on_ExpiryTimer_timeout() -> void:
	emit_signal("clean_up", self)
	#queue_free()



