extends Node2D

onready var heart_full_icon = preload("res://assets/img/player/heart_full.png")
onready var heart_empty_icon = preload("res://assets/img/player/heart_empty.png")

func render_hearts(full_hearts_count : int, empty_hearts_count : int):
	for i in full_hearts_count:
		var full_heart_sprite = Sprite.new()
		full_heart_sprite.texture = heart_full_icon
		add_child(full_heart_sprite)
		full_heart_sprite.position.x = i * 30
		
	for i in empty_hearts_count:
		var empty_heart_sprite = Sprite.new()
		empty_heart_sprite.texture = heart_empty_icon
		add_child(empty_heart_sprite)
		empty_heart_sprite.position.x = (i + full_hearts_count) * 30
