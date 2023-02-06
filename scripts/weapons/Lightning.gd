extends Node2D

signal clean_up(instance)

onready var sprite = $AnimatedSprite
onready var animation_player : AnimationPlayer = $AnimationPlayer
onready var line : Line2D = $Line2D	


func initialise_lightning(start_point : Vector2, end_point : Vector2):
	line.clear_points()
	line.add_point(start_point)
	line.add_point(end_point)
	animation_player.play("lightning")
#	sprite.global_position = Vector2(end_point.x - 5, end_point.y - 3)
#	sprite.frame = 0
#	sprite.play()


func _on_AnimationPlayer_animation_finished(anim_name: String) -> void:
	emit_signal("clean_up", self)
	#queue_free()


func _on_AnimatedSprite_animation_finished() -> void:
	sprite.stop()
	sprite.visible = false
