extends KinematicBody2D

signal player_health_updated(new_health_value, max_health)
signal player_hearts_updated(new_hearts_value, max_hearts)
signal player_died()
signal ready_for_results()
signal player_gained_exp(player_exp, max_exp)
signal player_levelled_up(player_level)
signal currency_aquired(worth)

onready var invincibility_timer = $InvincibilityTimer
onready var death_linger_timer = $DeathLingerTimer

onready var player_sprite = $Character
onready var weapon_sprite = $Weapon
onready var off_hand_sprite = $OffHand
onready var helmet_sprite = $Helmet
onready var chest_sprite = $Chest

var weapon_name : String = ""
var off_hand_name : String = ""
var helmet_name : String = ""
var chest_name : String = "" 

#var player_direction : Vector2 = Vector2()
#var last_direction : Vector2 = Vector2(-1000, 0)
#var player_sprite : Node = null

var player_speed : int = 80
var player_speed_bonus : int = 0
var player_max_health : float = 100.0
var player_health : float = 100.0
var player_max_hearts : float = 3.0
var player_hearts : float = 3.0
var player_level = 1
var player_exp : float = 0.0
var damage_reduction : int = 0 

var is_invincible = false
var is_dead = false

var level_exp_dict = {}
var panic_threshold : float = 25.0
var player_class : String = "Swords"
var player_facing = "left"
var player_velocity : Vector2 = Vector2()

var frames_per_log = 100
var current_frame = 1


func _ready() -> void:
	invincibility_timer.connect("timeout", self, "reset_invincibility")
	death_linger_timer.connect("timeout", self, "emit_ready_for_results")
#	player_sprite = get_node("AnimatedSprite")
	calculate_exp_thresholds()
	set_default_class_sprites()
	sync_equipment_animations()
	

func _physics_process(_delta):
	if not is_dead:
		move_player()	
	
	if not is_invincible and not is_dead:
		process_enemy_collisions()

	if current_frame == frames_per_log:
		current_frame = 1
#		print("WEAPON NAME: " + weapon_name)
#		print("OFF-HAND NAME: " + off_hand_name)
	else:
		current_frame += 1


func set_default_class_sprites():
	if player_class == "Swords":
		weapon_name = "Short Sword"
		weapon_sprite.animation = "Short Sword idle"
		off_hand_name = "Wooden Shield"
		off_hand_sprite.animation = "Wooden Shield idle"


func sync_equipment_animations():
	player_sprite.frame = 0
	helmet_sprite.frame = 0
	weapon_sprite.frame = 0
	off_hand_sprite.frame = 0
	chest_sprite.frame = 0


func calculate_exp_thresholds():
	var level = 1
	var exp_threshold = 4.0
	var exp_gain = 5.0
	
	for i in 250:		
		level_exp_dict[level] = exp_threshold		
		exp_threshold += exp_gain	
		level += 1	
		exp_gain += level				


func move_player():
	player_velocity = Vector2()
	
	if Input.is_action_pressed("up"):
		player_velocity.y -= 1
#		player_direction = Vector2(0, -1)
		
	if Input.is_action_pressed("down"):
		player_velocity.y += 1
#		player_direction = Vector2(0, 1)
		
	if Input.is_action_pressed("left"):
		player_velocity.x -= 1
#		player_direction = Vector2(-1, 0)
		player_facing = "left"
		
	if Input.is_action_pressed("right"):
		player_velocity.x += 1
#		player_direction = Vector2(1, 0)
		player_facing = "right"
	
	player_velocity = player_velocity.normalized()	
	var speed_multiplier = ((100.0 + float(player_speed_bonus)) / 100.0)
	var modified_speed = float(player_speed) * speed_multiplier
	player_velocity = move_and_slide(player_velocity * modified_speed)
	
	update_sprite_flips()
	update_sprite_animations()
			

func update_sprite_flips():
	player_sprite.flip_h = false if player_facing == "left" else true	
	helmet_sprite.flip_h = false if player_facing == "left" else true	
	weapon_sprite.flip_h = false if player_facing == "left" else true
	off_hand_sprite.flip_h = false if player_facing == "left" else true
	chest_sprite.flip_h = false if player_facing == "left" else true	


func update_sprite_animations():
	if player_velocity == Vector2.ZERO:
		player_sprite.animation = "idle" if player_health > panic_threshold else "idle_panic"
		helmet_sprite.animation = "idle" if helmet_name == "" else helmet_name + " idle"
		weapon_sprite.animation = "idle" if weapon_name == "" else weapon_name + " idle"
		off_hand_sprite.animation = "idle" if off_hand_name == "" else off_hand_name + " idle"
		chest_sprite.animation = "idle" if chest_name == "" else chest_name + " idle"
	else:
		player_sprite.animation = "moving" if player_health  > panic_threshold else "moving_panic" 
		helmet_sprite.animation = "moving" if helmet_name == "" else helmet_name + " moving"
		weapon_sprite.animation = "moving" if weapon_name == "" else weapon_name + " moving"
		off_hand_sprite.animation = "moving" if off_hand_name == "" else off_hand_name + " moving"
		chest_sprite.animation = "moving" if chest_name == "" else chest_name + " moving"


func process_enemy_collisions():
	for body in $EnemyCollisionDetector.get_overlapping_bodies():
		if body.is_in_group("enemies") and not body.is_dying:# and body.hitbox_delay >= 1.0:	
			if not body.is_stunned:
				take_damage(body.strength)
				break


func take_damage(damage : float):
	if not damage_reduction == null and damage_reduction > 0:
		damage = damage * ((100.0 - float(damage_reduction)) / 100.0)
	
	player_health -= damage
	is_invincible = true
	invincibility_timer.start()
	
#	if player_health <= 0:
#		start_death()	
	
	player_sprite.material.set_shader_param("flash_intensity", 0.7)	
	emit_signal("player_health_updated", player_health, player_max_health)	
	
	player_hearts -= 1.0
	emit_signal("player_hearts_updated", player_hearts, player_max_hearts)

	if player_hearts <= 0.0:
		start_death()


func heal(amount : float):
	if player_health + amount > player_max_health:
		player_health = player_max_health
	else:
		player_health += amount
		
	emit_signal("player_health_updated", player_health, player_max_health)
	
	player_hearts += 1
	emit_signal("player_hearts_updated", player_hearts, player_max_hearts)


func reset_invincibility():
	is_invincible = false
	player_sprite.material.set_shader_param("flash_intensity", 0.0)


func calculate_exp(exp_gained : float):
	player_exp += exp_gained	
	check_can_level_up()
	
	if player_level == 1:
		emit_signal("player_gained_exp", player_exp, level_exp_dict[1])
	else:
		var exp_margin = level_exp_dict[player_level] - level_exp_dict[player_level - 1]
		emit_signal("player_gained_exp", player_exp - level_exp_dict[player_level - 1], exp_margin)
	
	
func check_can_level_up():	
	if player_exp >= level_exp_dict.get(player_level):
		level_up()
		check_can_level_up()
		print('== LEVEL UP (' + str(player_level) + ') ==')
	
	
func level_up():
	player_level += 1
	emit_signal("player_levelled_up", player_level)	
	

func start_death():
	is_dead = true
	player_sprite.animation = "death"
	player_sprite.connect("animation_finished", self, "die")
	
	
func die():
	emit_death()
	player_sprite.stop()
	player_sprite.frame = 10	
	death_linger_timer.start()
	
	
func emit_death():
	emit_signal("player_died")
	

func emit_ready_for_results():
	emit_signal("ready_for_results")
	

func _on_PickupTriggerDetector_area_entered(area: Area2D) -> void:
	if area.has_method('pick_up'):
		if area.is_ejecting:
			area.attract_pickup() 
		else: #if pickup has been ejected and is waiting stationary on the ground
			area.pick_up(global_position)	


func _on_PickupCollectorDetector_area_entered(area: Area2D) -> void:
	if area.has_method('pick_up'):
		if area.is_being_attracted or area.is_ejecting:
			if area.has_method('initialise_exp_drop'):
				calculate_exp(area.exp_amount)
			elif area.has_method("initialise_food"):
				heal(area.healing_strength)
			elif area.has_method("initialise_currency"):
				emit_signal("currency_aquired", area.worth)
			
			area.unalive()
	elif area.has_method('open_treasure'):
		area.open_treasure()
