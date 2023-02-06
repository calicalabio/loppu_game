extends Node2D

onready var loading_label : Label = $Label
var load_time : float = 0.5
var dot_timer : float = 0.0
var dot_interval : float = 0.4
var dot_count : int = 3

func _process(delta: float) -> void:
	load_time -= delta
	
	if load_time <= 0.0:
		get_tree().change_scene("res://scenes/Main.tscn")
	
	update_loading_text(delta)


func update_loading_text(delta: float):
	dot_timer += delta
	
	if dot_timer >= dot_interval:
		dot_timer = 0.0
		dot_count += 1
	
	if dot_count > 3:
		dot_count = 1
	
	var dot_string = ""
	
	for i in dot_count:
		dot_string = dot_string + "."
	
	loading_label.text = "loading" + dot_string
