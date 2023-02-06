extends Node2D

onready var icon = $Icon
onready var cooldown = $Cooldown
onready var cooldown_tween = $CooldownTween
onready var frame = $Frame


func update_weapon_icons(weapon : Weapon):	
	icon.visible = true
	icon.set_texture(weapon.icon)
	frame.set_texture(weapon.frame)
	

func start_cooldown_indicator(cooldown_time : float):
	cooldown_tween.interpolate_property(cooldown, "value", 100, 0, cooldown_time)
	cooldown_tween.start()
