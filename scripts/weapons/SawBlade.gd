extends Area2D

signal clean_up(instance)

onready var sprite = $AnimatedSprite

#var rng = RandomNumberGenerator.new()
var player = null
var velocity = Vector2.ZERO
var chakram_data : Weapon = null
var acceleration : float = 2.0
#var speed : float = 0.0
#var damage : float = 0.0
#var min_damage : float = 0.0
#var max_damage : float = 0.0
#var crit_rate : float = 0.0
#var crit_damage : float = 0.0
#var can_knockback : bool = true

var is_extending = true
var is_spinning = false
var is_retracting = false


func _ready() -> void:
	$ExtendTimer.connect("timeout", self, "spin_in_place")
	$SpinTimer.connect("timeout", self, "retract_blade")
	$SpinDamageTimer.connect("timeout", self, "damage_enemies_in_spin")	
	

func _physics_process(_delta: float) -> void:
	if is_extending:
		global_position += velocity * _delta
	elif is_retracting:
		move_towards_player(_delta)
		var overlapping_areas = get_overlapping_areas()
		for area in overlapping_areas:
			if area.is_in_group("weapon_collectors"):
				is_retracting = false
				emit_signal("clean_up", self)


func initialise_sawblade(sawblade_data : Weapon, player_object : Node, travel_direction : Vector2):
#	rng.randomize()
	player = player_object
	chakram_data = sawblade_data
	global_position = player_object.global_position
	#rotation = Global.rng.randf_range(0, 2 * PI)
	rotation = travel_direction.angle()
#	speed = sawblade_data.projectile_speed	
	velocity = transform.x * chakram_data.projectile_speed
	sprite.global_rotation = 0
	
#	damage = sawblade_data.damage
#	min_damage = sawblade_data.min_damage
#	max_damage = sawblade_data.max_damage
#	crit_rate = sawblade_data.crit_rate
#	crit_damage = sawblade_data.crit_damage
#	can_knockback = sawblade_data.can_knockback
	
	is_extending = true
	$ExtendTimer.start()
	

func spin_in_place():
	is_extending = false
	is_spinning = true
	$SpinTimer.start()
	$SpinDamageTimer.start()
	

func retract_blade():
	is_spinning = false
	is_retracting = true
	$SpinDamageTimer.stop()
	

func move_towards_player(_delta):
	var direction_to_move = global_position.direction_to(player.global_position)
	
	if global_position.distance_to(player.global_position) < 20:
		chakram_data.projectile_speed = 50
#	if speed > 52.0:
#		speed = speed - acceleration
#	else:
#		speed = 50.0
		
	var new_velocity = direction_to_move * chakram_data.projectile_speed
	global_position += new_velocity * _delta


func damage_enemies_in_spin():
	for body in get_overlapping_bodies():
		if body.is_in_group("enemies") and not body.is_dying:
			var spin_damage = max(chakram_data.min_damage / 4.0, 1.0)
			body.take_damage(get_spin_weapon_data(spin_damage))			


func get_spin_weapon_data(spin_damage : float) -> Weapon:
	var spin_data = Weapon.new()
	
	spin_data.min_damage = spin_damage
	spin_data.max_damage = spin_damage
	spin_data.crit_rate = chakram_data.crit_rate
	spin_data.crit_damage = chakram_data.crit_damage
	spin_data.knockback_strength = 0.0
	
	return spin_data


func _on_SawBlade_body_entered(body: Node) -> void:
	if is_extending or is_retracting:
		if body.is_in_group("enemies") and not body.is_dying:
			body.take_damage(chakram_data)


func _on_CollectionBox_area_entered(area: Area2D) -> void:
	if is_retracting and area.is_in_group("weapon_collectors"):
		is_retracting = false
		emit_signal("clean_up", self)
