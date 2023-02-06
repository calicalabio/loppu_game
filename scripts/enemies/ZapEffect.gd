extends AnimatedSprite


func initialise_zap_effect():
	self.visible = true
	self.frame = 0
	self.play()


func _on_ZapEffect_animation_finished() -> void:
	self.stop()
	self.visible = false
