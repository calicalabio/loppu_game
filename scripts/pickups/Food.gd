extends "res://scripts/pickups/Pickup.gd"

onready var sprite = $AnimatedSprite

#var rng = RandomNumberGenerator.new()
var healing_strength : float = 10


#func _ready() -> void:
#	rng.randomize()


func initialise_food(spawn_location : Vector2, _target : Node):
	initialise_pickup(spawn_location, _target)
	
#	var type_roll = Global.rng.randi_range(0, 1)
#
#	if type_roll == 1:
#		sprite.animation = "cherry"
#	elif type_roll == 2:
#		sprite.animation = "egg"
	
#	sprite.animation = "egg"
#	sprite.play()
