extends Area2D

signal clean_up(instance)

onready var sprite = $AnimatedSprite
onready var hitbox_top = $HitBoxTop
onready var hitbox_middle = $HitBoxMiddle
onready var hitbox_bottom = $HitBoxBottom

var short_sword_data : Weapon = null
var player : Node = null
var hitbox_top_default_x : float = 0.0
var hitbox_middle_default_x : float = 0.0
var hitbox_bottom_default_x : float = 0.0
	
	
func _ready() -> void:
	hitbox_top_default_x = hitbox_top.position.x
	hitbox_middle_default_x = hitbox_middle.position.x
	hitbox_bottom_default_x = hitbox_bottom.position.x
	

func initialise_short_sword(weapon_data : Weapon, player_node : Node):
	short_sword_data = weapon_data
	player = player_node
	
	hitbox_top.position.x = hitbox_top_default_x
	hitbox_middle.position.x = hitbox_middle_default_x
	hitbox_bottom.position.x = hitbox_bottom_default_x
	
	if player.player_facing == "right": #this flips the hitboxes so they hit to the right instead
		hitbox_top.position.x *= -1
		hitbox_middle.position.x *= -1
		hitbox_bottom.position.x *= -1
	
	sprite.flip_h = false if player.player_facing == "left" else true
	
	if player.player_facing == "left":
		self.global_position = Vector2(player.global_position.x - 30, player.global_position.y - 10)
	else:
		self.global_position = Vector2(player.global_position.x + 30, player.global_position.y - 10)
		
	sprite.frame = 0
	sprite.play()
		
		
func hit():
	var enemies_hit = get_overlapping_bodies()
	
	for body in enemies_hit:
		if body.is_in_group("enemies") and not body.is_dying:
			body.take_damage(short_sword_data)


func _on_AnimatedSprite_frame_changed() -> void:
	if sprite.frame == 2:
		hit()


func _on_AnimatedSprite_animation_finished() -> void:
	emit_signal("clean_up", self)



