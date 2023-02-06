extends AnimatedSprite

var sparkle_position : Vector2 = Vector2.ZERO


func _process(delta: float) -> void:
	self.global_position = sparkle_position


func initialise_sparkle(spawn_point : Vector2):
	sparkle_position = spawn_point
	self.connect("animation_finished", self, "unalive")
	self.play()
	

func unalive():
	queue_free()
