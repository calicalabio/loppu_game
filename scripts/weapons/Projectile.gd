extends Area2D

signal clean_up(instance)

var projectile_data : Weapon = null
var velocity : Vector2 = Vector2.ZERO
#var min_damage : float = 0.0
#var max_damage : float = 0.0
#var penetration : int = 1
#var duration : float = 0.0
var marked_enemies : Array = []
#var can_stun : bool = false
#var stun_duration : float = 0.0
var duration_timer : Timer = null
var on_hit_method : String = ""
var ignore_penetration : bool = false
var projectile_duration : float = 1.0


#func _ready() -> void:
	#this only checks for enemy collisions once a body enters the projectile area
	#better performance but can damage multiple enemies at the same time if it spawns on top of multiple enemies (even with a penetration of 1)
	#connect("body_entered", self, "handle_collision")
#	pass


func _physics_process(_delta):
	global_position += velocity * _delta	
	
	#this checks for enemy collisions every frame
	#potentially more performance intensive
	for enemy in get_overlapping_bodies():
		handle_collision(enemy)
		
		if projectile_data.penetration == 0:
			break
	
#   old version that doesn't work wtf:
#	velocity = global_position.direction_to(target_position).normalized()
#	global_position += velocity * speed * _delta


func initialise_projectile(_target_direction : Vector2, weapon_data : Weapon, _spawn_position : Vector2, duration_override, _ignore_penetration : bool):
	marked_enemies = []
	set_projectile_properties(_target_direction, weapon_data, _spawn_position, duration_override, _ignore_penetration)	
	start_duration_timer()


func set_projectile_properties(_target_direction : Vector2, weapon_data : Weapon, _spawn_position : Vector2, duration_override, _ignore_penetration : bool):
	projectile_data = weapon_data
#	min_damage = weapon_data.min_damage
#	max_damage = weapon_data.max_damage	
#	penetration = weapon_data.penetration	
	ignore_penetration = _ignore_penetration
	
#	can_stun = weapon_data.can_stun
#	stun_duration = weapon_data.stun_duration
	
	rotation = _target_direction.angle()
	velocity = transform.x * weapon_data.projectile_speed
	global_position = _spawn_position	
	
	if not duration_override == null:
		projectile_duration = duration_override
	else:
		projectile_duration = weapon_data.duration


func start_duration_timer():
	if duration_timer == null:
		var new_duration_timer = Timer.new()
		new_duration_timer.one_shot = true
		new_duration_timer.set_wait_time(projectile_duration)
		new_duration_timer.connect("timeout", self, "expire")
		add_child(new_duration_timer)
		new_duration_timer.start()
		duration_timer = new_duration_timer
	else:
		duration_timer.set_wait_time(projectile_duration)
		duration_timer.start()
	

func handle_collision(body : Node):
	if not marked_enemies.has(body) and body.is_in_group("enemies") and not body.is_dying:
		if on_hit_method.empty():			
			body.take_damage(projectile_data)
			
			if projectile_data.can_stun:
				body.stun(projectile_data.stun_duration)
			
			marked_enemies.append(body)
			
			if not ignore_penetration:
				projectile_data.penetration -= 1
				
				if projectile_data.min_damage > 1:
					projectile_data.min_damage = projectile_data.min_damage * 0.75
					projectile_data.max_damage = projectile_data.max_damage * 0.75
					
				if projectile_data.penetration == 0:
					expire()		
		else:
			call(on_hit_method)


func expire():
	duration_timer.stop()
	emit_signal("clean_up", self)

