extends Area2D

signal player_entered_zone(zone_name)

func _on_Zone_body_entered(body: Node) -> void:
	if body.has_method('move_player'):
		emit_signal("player_entered_zone", self.get_name())
