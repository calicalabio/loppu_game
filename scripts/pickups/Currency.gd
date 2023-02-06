extends "res://scripts/pickups/Pickup.gd"

onready var animated_sprite = $AnimatedSprite
onready var sprite = $Sprite

onready var one = preload("res://assets/img/gold_01.png")
onready var two = preload("res://assets/img/gold_02.png")
onready var three = preload("res://assets/img/gold_03.png")
onready var four = preload("res://assets/img/gold_04.png")
onready var five = preload("res://assets/img/gold_05.png")

var worth : float = 1


func initialise_currency(spawn_location : Vector2, _target : Node):
	var roll = Global.rng.randi_range(1, 100)
	
	if roll <= 2:
		worth = 5
		sprite.texture = five
	elif roll <= 8:
		worth = 4
		sprite.texture = four
	elif roll <= 20:
		worth = 3
		sprite.texture = three
	elif roll <= 40:
		worth = 2
		sprite.texture = two
	elif roll <= 100: 
		worth = 1
		sprite.texture = one
	
	initialise_pickup(spawn_location, _target)
