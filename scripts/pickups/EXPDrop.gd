extends "res://scripts/pickups/Pickup.gd"

onready var sprite = $AnimatedSprite

var exp_amount = 1

func initialise_exp_drop(spawn_position : Vector2, pickup_target : Node, type : int):
	initialise_pickup(spawn_position, pickup_target)
	
	match type:
		0: #small
			exp_amount = 1
			sprite.animation = "small"
		1: #large
			exp_amount = 10
			sprite.animation = "large"
			
#	match type:
#		0: #small
#			exp_amount = 1
#			$SmallSprite.visible = true
##			get_node("AnimatedSprite").animation = "small"
#		1: #medium
#			exp_amount = 10
#			$MediumSprite.visible = true
##			get_node("AnimatedSprite").animation = "medium"
#		2: #large
#			exp_amount = 100
#			$LargeSprite.visible = true
##			get_node("AnimatedSprite").animation = "large"
#		3: #extra_large
#			exp_amount = 1000
#			$ExtraLargeSprite.visible = true
##			get_node("AnimatedSprite").animation = "extra_large"
	

