extends CanvasLayer

signal scene_changed()

onready var animation_player = $AnimationPlayer
onready var control = $Control
onready var black = $Control/Black


func change_scene():
	control.visible = true	
	animation_player.play("fade_out")


func _on_AnimationPlayer_animation_finished(anim_name: String) -> void:
	assert(get_tree().change_scene("res://scenes/Loading.tscn") == OK) #will crash if you can't find the scene - for debugging purposes
	
