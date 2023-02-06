extends Area2D

signal clean_up(instance)

onready var sprite = $AnimatedSprite
onready var hit_timer = $HitTimer
onready var expiry_timer = $ExpiryTimer

var impale_data : Weapon = null


func initialise_impale(weapon_data : Weapon, target_position : Vector2, spawn_position : Vector2):
	impale_data = weapon_data
	self.global_position = spawn_position
	self.rotation = (target_position - spawn_position).angle()
	
	sprite.connect("animation_finished", self, "linger_impale")	
	sprite.frame = 0
	sprite.play()
	hit_timer.start()
	
	
func linger_impale():
	sprite.stop()
	sprite.frame = 9
	

func hit():
	var enemies_hit = get_overlapping_bodies()
	
	for body in enemies_hit:
		if body.is_in_group("enemies") and not body.is_dying:
			body.take_damage(impale_data)
			body.stun(impale_data.stun_duration)

	expiry_timer.start()


func _on_HitTimer_timeout() -> void:
	hit()


func _on_ExpiryTimer_timeout() -> void:
	emit_signal("clean_up", self)
	#queue_free()



