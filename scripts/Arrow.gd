extends Node2D

onready var sprite = $AnimatedSprite


func _physics_process(_delta: float) -> void:
	#camera's transform (position + scale) - doesn't store dimensions of camera
	var canvas = get_canvas_transform()
	#canvas.origin is the unscaled inverted top-left of the camera
	var origin = -canvas.origin
	#minusing 16px from top cause of HUD top bar
	origin.y = origin.y + 16
	var top_left = origin / canvas.get_scale()
	#gets dimensions of camera
	var size = get_viewport_rect().size / canvas.get_scale()
	
	set_arrow_position(Rect2(top_left, size))
	set_arrow_rotation()
	

func set_arrow_position(bounds : Rect2):
	sprite.global_position.x = clamp(global_position.x, bounds.position.x, bounds.end.x)
	sprite.global_position.y = clamp(global_position.y, bounds.position.y, bounds.end.y)
	sprite.visible = false if bounds.has_point(self.global_position) else true


func set_arrow_rotation():
	var angle = (self.global_position - sprite.global_position).angle()
	sprite.global_rotation = angle
		
