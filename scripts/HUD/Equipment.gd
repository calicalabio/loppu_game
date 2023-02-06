extends Node2D

onready var helmet = $Panels/Helmet
onready var weapon = $Panels/Weapon
onready var off_hand = $Panels/OffHand
onready var chest = $Panels/Chest


func update_icons(equipment : Dictionary):
	if equipment.has("helmet"):
		helmet.visible = true
		helmet.set_texture(equipment["helmet"].icon)
	
	if equipment.has("weapon"):
		weapon.visible = true
		weapon.set_texture(equipment["weapon"].icon)
		
	if equipment.has("off_hand"):
		off_hand.visible = true
		off_hand.set_texture(equipment["off_hand"].icon)
	
	if equipment.has("chest"):
		chest.visible = true
		chest.set_texture(equipment["chest"].icon)
