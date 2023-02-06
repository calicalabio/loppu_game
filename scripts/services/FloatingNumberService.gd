extends Node2D

onready var floating_number_scene = preload("res://scenes/FloatingNumber.tscn")

#var rng = RandomNumberGenerator.new()
var max_numbers : int = 250
var number_pool : Array = []
var next_number : int = 0

func _ready():
	for i in max_numbers:
		var new_number = floating_number_scene.instance()
		number_pool.append(new_number)
		self.call_deferred('add_child', new_number)


func spawn_floating_number(damage : float, spawn_coordinates : Vector2, is_crit : bool):
	var number = number_pool[next_number]
	number.initialise_floating_number(damage, spawn_coordinates, is_crit)#(damage, spawn_coordinates, is_crit, rng)
	iterate_next_number()
	

func iterate_next_number():
	if next_number == number_pool.size() - 1:
		next_number = 0
	else:
		next_number += 1
