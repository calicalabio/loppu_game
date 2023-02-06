extends Area2D

signal door_entered()


func initialise_door(base_position : Vector2):
	self.global_position = Vector2(base_position.x, base_position.y - 100)


func try_enter_door(body : Node):
	if body.is_in_group("player"):
		emit_signal("door_entered")


func _on_Door_body_entered(body: Node) -> void:
	try_enter_door(body)
