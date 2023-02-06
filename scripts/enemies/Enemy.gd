extends KinematicBody2D

signal boss_died(death_coordinates)
signal enemy_damaged(damage, enemy_coordinates, is_crit)
signal enemy_died(death_coordinates)
signal clean_up(instance)

onready var status_effect_icon = $StatusEffect
onready var fire_icon = preload("res://assets/img/effects/fire_status.png")
onready var ice_icon = preload("res://assets/img/effects/ice_status.png")
onready var lightning_icon = preload("res://assets/img/effects/lightning_status.png")

onready var damage_number_scene = preload("res://scenes/FloatingNumber.tscn")
#onready var sprite = $AnimatedSprite
onready var sprite = $Sprite
onready var stun_effect = $StunEffect
onready var crit_effect = $CritEffect
onready var zap_effect = $ZapEffect
onready var collision_shape = $CollisionShape2D
onready var collision_activation_timer = $CollisionActivationTimer
onready var expiry_timer = $ExpiryTimer

var is_boss : bool = false
export var is_swarmer : bool = false

var physics_interval : int = 1
var physics_calls : int = 0

var target : KinematicBody2D = null
var velocity : Vector2 = Vector2()
export var speed : int  = 25.0
export var max_health : float = 10.0
export var health : float = 10.0
export var strength : float = 10.0
var time_created = 0

var knockback_acceleration = 0.0
var damaged_duration = 0.0
var flip_timeout = 0.0
var is_dying = false
var is_stunned = false
var stun_time_remaining : float = 0.0
var fixed_velocity : Vector2 = Vector2.ZERO

var status_effect = null #{ "fire" : "hydra" }
var status_duration_timer : Timer = null #the overall duration of the status effect
var status_tick_timer : Timer = null #deals damage or inflicts an effect per timeout

#func _ready():
#	rng.randomize()
	

func initialise_enemy(_target : Node, _is_boss : bool):	
	health = max_health
	target = _target
	is_boss = _is_boss
	
	velocity = Vector2.ZERO
	knockback_acceleration = 0
	is_dying = false
#	sprite.animation = "default"
#	sprite.play()
	stun_time_remaining = 0.0
	collision_activation_timer.start()
	
	if is_swarmer:
		fixed_velocity = global_position.direction_to(target.global_position).normalized() 
		expiry_timer.connect("timeout", self, "clean_up")
		expiry_timer.start()
		

func _ready() -> void:
	collision_activation_timer.connect("timeout", self, "activate_collision")
#	request_ready()


func activate_collision():
	collision_shape.set_deferred("disabled", false)
		
		
func _physics_process(_delta):	
	if not is_dying:
		if knockback_acceleration < 0:
			knockback_acceleration += 5
		else:
			knockback_acceleration = 0
		
		if is_stunned:
			update_stun_state(_delta)
		else:
			if not is_swarmer:
				update_flip(_delta)	
			
			move_towards_player(_delta)
	
	if not is_swarmer:
		check_can_teleport_to_player()
	
	update_damaged_state(_delta)


func check_can_teleport_to_player():
	var player_location = target.global_position
	var current_location = self.global_position
	var vertical_leash_distance = (Global.game_height / 2) + 140 #180 + 140
	var horizontal_leash_distance = (Global.game_width / 2) + 140 #320 + 140
	
	#if enemy is over X units ABOVE player
	if player_location.y - current_location.y > vertical_leash_distance:#player below enemy
		if is_boss:
			self.global_position.y = player_location.y + vertical_leash_distance - 50
		else:
			clean_up()
	elif current_location.y - player_location.y > vertical_leash_distance:#player above enemy
		if is_boss:
			self.global_position.y = player_location.y - vertical_leash_distance + 50
		else:
			clean_up()
	elif player_location.x - current_location.x > horizontal_leash_distance:#player to the right of enemy
		if is_boss:
			self.global_position.x = player_location.x + horizontal_leash_distance - 50
		else:
			clean_up()
	elif current_location.x - player_location.x > horizontal_leash_distance: #player to the left of enemy
		if is_boss:
			self.global_position.x = player_location.x - horizontal_leash_distance + 50
		else:
			clean_up()

	
func move_towards_player(_delta):
	if not is_swarmer:
		if global_position.distance_to(target.global_position) > 5:
			velocity = global_position.direction_to(target.global_position).normalized()
			velocity = move_and_slide(velocity * (speed + knockback_acceleration))
	else:
		move_and_slide(fixed_velocity * (speed + knockback_acceleration))


func update_flip(_delta):
	flip_timeout += _delta
	
	if flip_timeout > 1.0:
		flip_timeout = 0.0
		
		if global_position.x > target.global_position.x:
			sprite.flip_h = false
		else:
			sprite.flip_h = true	


#func take_damage(min_damage : float, max_damage : float, crit_rate : float, crit_damage : float, can_knockback : bool):
func take_damage(weapon_data : Weapon):
	var is_crit = calculate_will_crit(weapon_data.crit_rate)
	var damage_taken = calculate_damage_taken(weapon_data.min_damage, weapon_data.max_damage, is_crit, weapon_data.crit_damage)
	apply_damage(damage_taken, is_crit)
	
	if is_crit:
		play_crit_effect()
	
	if (health <= 0):
		start_death()	
	
	apply_knockback(weapon_data)
	apply_status_effects(weapon_data)


func apply_damage(damage_amount : float, is_crit : bool):
	health -= damage_amount	
	emit_signal("enemy_damaged", damage_amount, global_position, is_crit)
	sprite.material.set_shader_param("flash_intensity", 0.7)	
	damaged_duration = 0.1
	

func calculate_will_crit(crit_rate : float) -> bool:
	var crit_roll = Global.rng.randf_range(0.0, 100.0)	
	return crit_roll <= crit_rate


func calculate_damage_taken(min_damage : float, max_damage : float, is_crit : bool, crit_damage : float) -> float:
	var damage = Global.rng.randf_range(min_damage, max_damage)

	if is_crit:
		return damage + (damage * (crit_damage / 100.0))
	else:
		return damage
	

func update_damaged_state(_delta : float):
	if damaged_duration > 0:
		damaged_duration -= _delta	
	elif damaged_duration < 0:
		damaged_duration = 0.0
		sprite.material.set_shader_param("flash_intensity", 0.0)


func start_death():	
	is_dying = true
	#self.remove_from_group("enemies")
	#self.set_collision_layer_bit(0, false)
	#self.set_collision_layer_bit(9, true)
	collision_shape.set_deferred("disabled", true)
	play_death_animation()	


func play_death_animation():
#	sprite.animation = "death"
#	sprite.connect("animation_finished", self, "handle_finished_death_animation")
	kill() #for un-animated placeholders


func handle_finished_death_animation():
	if sprite.animation == "death" and is_dying:
		kill()


func kill():
	emit_signal("enemy_died", global_position)
	
	if is_boss:
		emit_signal("boss_died", global_position)	
	
	#self.global_position = Vector2(-5000, -5000) #don't think this actually helps with anything atm - was a failed attempt at fixing the phantom hit bug
	clean_up()
	#queue_free()


func clean_up():
	remove_status_effects()
	emit_signal("clean_up", self)


func play_crit_effect():
	crit_effect.initialise_crit_effect(sprite.flip_h)


func play_zap_effect():
	zap_effect.initialise_zap_effect()


func stun(stun_duration : float):
	if stun_duration > stun_time_remaining:
		stun_effect.visible = true
		stun_time_remaining = stun_duration
		is_stunned = true
	
	
func end_stun():
	stun_effect.visible = false
	is_stunned = false
	
	
func update_stun_state(_delta : float):
	stun_time_remaining -= _delta
	
	if stun_time_remaining <= 0.0:
		end_stun()


func apply_knockback(weapon_data : Weapon):
	var knockback_speed = 75.0
	
	if weapon_data.knockback_strength > 0.0:
		knockback_acceleration = -(knockback_speed * weapon_data.knockback_strength)


func apply_status_effects(weapon_data : Weapon):
	if not status_effect == null and status_effect.has("fire") and weapon_data.code_name == status_effect["fire"].code_name:
		status_duration_timer.set_wait_time(10.0)
		status_duration_timer.start()
		return
	elif not status_effect == null and status_effect.has("ice") and weapon_data.code_name == status_effect["ice"].code_name:
		status_duration_timer.set_wait_time(6.0)
		status_duration_timer.start()
		return
	elif not status_effect == null and status_effect.has("lightning") and weapon_data.code_name == status_effect["lightning"].code_name:
		status_duration_timer.set_wait_time(3.8)
		status_duration_timer.start()
		return
	
	if not status_effect == null:	
		remove_status_effects()
	
	if status_duration_timer == null:
		status_duration_timer = Timer.new()
		status_duration_timer.one_shot = true	
		status_duration_timer.connect("timeout", self, "remove_status_effects")	
		add_child(status_duration_timer)		
		
	if status_tick_timer == null:
		status_tick_timer = Timer.new()
		status_tick_timer.one_shot = false	
		status_tick_timer.connect("timeout", self, "apply_status_tick")	
		add_child(status_tick_timer)
	
	if weapon_data.damage_type == "fire":
		apply_fire_status(weapon_data)
	elif weapon_data.damage_type == "ice":
		apply_ice_status(weapon_data)		
	elif weapon_data.damage_type == "lightning":
		apply_lightning_status(weapon_data)
		

func apply_fire_status(weapon_data : Weapon):
	status_effect_icon.set_texture(fire_icon)
	status_effect_icon.visible = true
	status_effect = { "fire" : weapon_data }		
	
	status_tick_timer.set_wait_time(1.0)
	status_tick_timer.start()
	status_duration_timer.set_wait_time(10.0)				
	status_duration_timer.start()
	

func apply_ice_status(weapon_data : Weapon):
	status_effect_icon.set_texture(ice_icon)
	status_effect_icon.visible = true
	status_effect = { "ice" : weapon_data }		
	
	status_duration_timer.set_wait_time(6.0)
	status_duration_timer.start()
	speed = speed * 0.5
	

func apply_lightning_status(weapon_data : Weapon):
	status_effect_icon.set_texture(lightning_icon)
	status_effect_icon.visible = true
	status_effect = { "lightning" : weapon_data }		
	
	status_tick_timer.set_wait_time(1.0)
	status_tick_timer.start()
	status_duration_timer.set_wait_time(3.8)		
	status_duration_timer.start()


func apply_status_tick():
	if status_effect.has("fire"):
		apply_damage(max(status_effect["fire"].max_damage / 10.0, 1.0), false)
	elif status_effect.has("lightning"):
		stun(0.5)
		

func remove_status_effects():
	if not status_effect == null:
		if status_effect.has("ice"):
			speed = (speed / 5.0) * 10.0
		
		if not status_duration_timer == null:
			status_duration_timer.stop()
		
		if not status_tick_timer == null:
			status_tick_timer.stop()

		status_effect = null
		status_effect_icon.visible = false
