extends Area2D

signal needs_target(this_bingling)
signal clean_up(instance)

onready var sprite = $AnimatedSprite
onready var explosion = $ExplosionSprite
onready var targetting_timer = $TargettingTimer
onready var aoe = $AOE
onready var expiry_timer = $ExpiryTimer

var bingling_data : Weapon = null
var target : Node = null
var is_exploding : bool = false
var is_dead : bool = false


func _physics_process(delta: float) -> void:
	if not is_dead:
		if is_exploding:
			for body in aoe.get_overlapping_bodies():
				if body.is_in_group("enemies") and not body.is_dying:
					body.take_damage(bingling_data)
		
			is_dead = true	
		elif is_instance_valid(target) and not target.is_dying:
			sprite.animation = "roll"
			sprite.play()
			move_towards_target()
		elif not is_instance_valid(target) or target.is_dying:
			sprite.animation = "default"
			try_acquire_target()		
		

func initialise_bingling(weapon_data : Weapon, spawn_position : Vector2, targetted_enemy : Node):
	is_exploding = false
	is_dead = false
	sprite.visible = true
	self.global_position = spawn_position
	bingling_data = weapon_data
	target = targetted_enemy		
	targetting_timer.connect("timeout", self, "try_acquire_target")
	targetting_timer.start()	
	expiry_timer.start()
	
	
func move_towards_target():	
	if not target.is_dying and is_instance_valid(target):
		var velocity = self.global_position.direction_to(target.global_position).normalized()
		self.global_position = self.global_position + velocity * bingling_data.projectile_speed 
		
		if self.global_position.x < target.global_position.x:
			sprite.flip_h = true
		else:
			sprite.flip_h = false


func try_acquire_target():
	emit_signal("needs_target", self)	


func set_target(enemy : Node):
	target = enemy
	sprite.animation = "roll"


func explode():
	is_exploding = true
	sprite.visible = false
	explosion.visible = true
	explosion.frame = 0
	explosion.play()	


func _on_Bingling_body_entered(body: Node) -> void:
	if not is_dead:
		if body.is_in_group("enemies") and not body.is_dying:
			explode()


func _on_ExplosionSprite_animation_finished() -> void:
	explosion.stop()
	explosion.visible = false	
	expire()


func expire():
	emit_signal("clean_up", self)


func _on_ExpiryTimer_timeout() -> void:
	explode()
