extends Node2D

signal player_entered_door()
signal player_opened_treasure()

onready var exp_drop_scene = preload("res://scenes/pickups/EXPDrop.tscn")
onready var food_scene = preload("res://scenes/pickups/Food.tscn")
onready var currency_scene = preload("res://scenes/pickups/Currency.tscn")
onready var treasure_scene = preload("res://scenes/pickups/Treasure.tscn")
onready var door_scene = preload("res://scenes/pickups/Door.tscn")


func try_drop_item(spawn_location : Vector2, player : Node):
	if will_drop_exp(player):
		spawn_exp_drop(spawn_location, player)
		
	if will_drop_currency():
		spawn_currency(spawn_location, player)
		
	if will_drop_food():
		spawn_food(spawn_location, player)
		
		
func will_drop_exp(player : Node) -> bool:
	if player.player_level <= 3:
		return true
	
	var exp_roll = Global.rng.randi_range(1, 100)
	return exp_roll <= 80
	
func will_drop_currency() -> bool:
	var currency_roll = Global.rng.randi_range(1, 100)
	return currency_roll <= 5

func will_drop_food() -> bool:
	var food_roll = Global.rng.randi_range(1, 200)
	return food_roll <= 1
	

#func will_drop(player_level : int) -> bool:
#	if player_level <= 3:
#		return true
#
#	var drop_roll = Global.rng.randi_range(1, 100)
#	return true if drop_roll <= 80 else false 


#func roll_drop_type(player_level : int) -> String:
#	if player_level <= 3:
#		return "exp"
#
#	var drop_type_roll = Global.rng.randi_range(1, 200)
#
#	if drop_type_roll <= 1:
#		return "food"
#	elif drop_type_roll <= 21:
#		return "currency"
#	else: 
#		return "exp"


func spawn_exp_drop(spawn_location : Vector2, player : Node):
	var max_exp_drop_size = 0

	if player.player_level > 20:
		max_exp_drop_size = 1
	
	var max_exp_drop_amount = 1
	
	if player.player_level > 5:
		max_exp_drop_amount = 2
	elif player.player_level > 10:
		max_exp_drop_amount = 3
	elif player.player_level > 15:
		max_exp_drop_amount = 5
	elif player.player_level > 20:
		max_exp_drop_amount = 8
	elif player.player_level > 25:
		max_exp_drop_amount = 10
	
	var amount_to_drop = Global.rng.randi_range(1, max_exp_drop_amount)	
	
	for	i in amount_to_drop:
		var exp_type = Global.rng.randi_range(0, max_exp_drop_size)
		var new_exp_drop = exp_drop_scene.instance()
		add_child(new_exp_drop)	
		new_exp_drop.initialise_exp_drop(spawn_location, player, exp_type)


func spawn_currency(spawn_location : Vector2, player : Node):
	var amount_of_coins = Global.rng.randi_range(1, 3)
	
	for i in amount_of_coins:
		var new_currency = currency_scene.instance()
		add_child(new_currency)
		new_currency.initialise_currency(spawn_location, player)


func spawn_food(spawn_location : Vector2, player : Node):
	var new_food = food_scene.instance()
	add_child(new_food)
	new_food.initialise_food(spawn_location, player)
	

func spawn_chest(base_location : Vector2):
	var new_treasure = treasure_scene.instance()		
	add_child(new_treasure)
	new_treasure.initialise_treasure(base_location)
	new_treasure.connect("treasure_opened", self, "handle_opened_treasure")


func handle_opened_treasure():
	emit_signal("player_opened_treasure")


func spawn_door(base_position : Vector2):
	var new_door = door_scene.instance()	
	add_child(new_door)
	new_door.initialise_door(base_position)
	new_door.connect("door_entered", self, "handle_entered_door")


func handle_entered_door():
	emit_signal("player_entered_door")
