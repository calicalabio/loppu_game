extends "res://scripts/weapons/Projectile.gd"

onready var aoe = $AOE


func _ready() -> void:
	on_hit_method = "explode"


func explode():
	var bodies = aoe.get_overlapping_bodies()
	
	for body in bodies:
		if body.is_in_group("enemies") and not body.is_dying:			
			body.take_damage(projectile_data)
			
	expire()
	
	
