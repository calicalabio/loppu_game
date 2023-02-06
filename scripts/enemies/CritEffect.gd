extends AnimatedSprite


func initialise_crit_effect(is_flipped : bool):
	if is_flipped:
		self.flip_h = true
		self.offset.x = -45.0
	else:
		self.flip_h = false
		self.offset.x = 0.0
	
	self.visible = true
	self.frame = 0
	self.play()


func _on_CritEffect_animation_finished() -> void:
	self.stop()
	self.visible = false
