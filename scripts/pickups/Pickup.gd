extends Area2D

var target : KinematicBody2D = null
var pickup_speed = 250
var ejection_speed = 125
var speed = 250
var pickup_acceleration = 15
var ejection_acceleration = 5

var is_ejecting = true
var ejection_direction : Vector2 = Vector2.ZERO

var is_being_picked_up = false
var is_being_repelled = false
var is_being_attracted = false


func _physics_process(_delta):
	if is_ejecting:
		if speed > 0:
			global_position += speed * ejection_direction * _delta
			speed -= ejection_acceleration
		else:
			is_ejecting = false
	
	if is_being_repelled:
		move(_delta, false)
		
	if is_being_attracted:
		move(_delta, true)


func initialise_pickup(spawn_position : Vector2, pickup_target : Node):
	speed = ejection_speed
	global_position = spawn_position
	target = pickup_target
	ejection_direction = Vector2(1, 0).rotated(deg2rad(Global.rng.randi_range(0, 360)))
	is_ejecting = true


func pick_up(player_position : Vector2):	
	if not is_being_picked_up:
		speed = pickup_speed
		
		is_being_picked_up = true
		is_being_repelled = true
		
		var repel_timer = Timer.new()
		repel_timer.one_shot = true
		repel_timer.set_wait_time(0.3)
		repel_timer.connect("timeout", self, "attract_pickup")
		add_child(repel_timer)
		repel_timer.start()		
	

func attract_pickup():
	if is_ejecting:
		is_ejecting = false
		speed = pickup_speed / 2
		
	is_being_repelled = false
	is_being_attracted = true
	

func move(_delta, towards_player : bool):
	var direction_to_move = global_position.direction_to(target.global_position) if towards_player else target.global_position.direction_to(global_position)	
	speed += pickup_acceleration if towards_player else (pickup_acceleration * -1)
	var velocity = direction_to_move * speed
	global_position += velocity * _delta


func unalive():
	if is_being_attracted:
		queue_free()
