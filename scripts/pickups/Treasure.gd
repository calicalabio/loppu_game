extends Area2D

signal treasure_opened()

onready var common_sprite = $Common
onready var rare_sprite = $Rare


func initialise_treasure(base_position : Vector2):
	self.global_position = base_position
	var chest_roll = Global.rng.randi_range(1, 100)
	
	if chest_roll <= 10:
		common_sprite.visible = false
		rare_sprite.visible = true
	else:
		common_sprite.visible = true
		rare_sprite.visible = false


func open_treasure():
	print("chest opened!")
	emit_signal("treasure_opened")
	queue_free()


