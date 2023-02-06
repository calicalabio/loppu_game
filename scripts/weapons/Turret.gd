extends Node2D

signal clean_up(instance)

onready var sprite = $AnimatedSprite
onready var attack_timer = $AttackTimer
onready var expiry_timer = $ExpiryTimer

var turret_data : Weapon = null


func _ready():
	sprite.connect("animation_finished", self, "idle")
	sprite.play()
	

func idle():
	sprite.animation = "default"
	
	
func initialise_turret(weapon_data : Weapon, can_expire : bool):
	sprite.animation = "spawn"
	sprite.frame = 0
	sprite.play()
	
	attack_timer.set_wait_time(weapon_data.fire_rate)
	attack_timer.connect("timeout", self, "trigger_attack")	
	attack_timer.start()

	if can_expire:
		expiry_timer.set_wait_time(weapon_data.duration)
		expiry_timer.connect("timeout", self, "expire")
		expiry_timer.start()

	turret_data = weapon_data


func expire():
	attack_timer.stop()
	expiry_timer.stop()
	emit_signal("clean_up", self)
