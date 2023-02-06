extends Node2D

signal treasure_selected(equipment)

onready var unfocused = preload("res://assets/img/equipment/btn_item_unfocused.png")
onready var focused = preload("res://assets/img/equipment/btn_item_focused.png")

onready var ghost_button = $Panel/GhostButton
onready var equipment_one = $Panel/EquipmentOne
onready var equipment_two = $Panel/EquipmentTwo
onready var equipment_three = $Panel/EquipmentThree

#onready var button_one = $Panel/TreasureOne/ButtonOne
#onready var button_two = $Panel/TreasureTwo/ButtonTwo
#onready var button_three = $Panel/TreasureThree/ButtonThree
#
#onready var icon_one = $Panel/TreasureOne/Icon
#onready var icon_two = $Panel/TreasureTwo/Icon
#onready var icon_three = $Panel/TreasureThree/Icon
#
#onready var title_one = $Panel/TreasureOne/Title
#onready var title_two = $Panel/TreasureTwo/Title
#onready var title_three = $Panel/TreasureThree/Title
#
#onready var description_one = $Panel/TreasureOne/Description
#onready var description_two = $Panel/TreasureTwo/Description
#onready var description_three = $Panel/TreasureThree/Description

var equipment : Array = []


#func _input(event: InputEvent) -> void:
#	if self.visible == true:
#		if event.is_action_pressed("ui_up") or event.is_action_pressed("ui_down") or event.is_action_pressed("up") or event.is_action_pressed("down"):
#			if not button_one.has_focus() and not button_two.has_focus() and not button_three.has_focus():
#				ghost_button.grab_focus()


func show_treasure(generated_equipment : Array):
	self.visible = true
	equipment = generated_equipment
	
	set_default_button_textures()	
	
	equipment_two.release_focus()
	equipment_three.release_focus()
	equipment_one.grab_focus()
	equipment_one.set_normal_texture(focused)
#	button_one.release_focus()
#	button_two.release_focus()
#	button_three.release_focus()
	
	equipment_one.setup(equipment[0])
	equipment_two.setup(equipment[1])
	equipment_three.setup(equipment[2])
	
#	set_icons()
#	set_titles()
#	set_descriptions()
	
	
func set_default_button_textures():
	equipment_one.set_normal_texture(unfocused)
	equipment_two.set_normal_texture(unfocused)
	equipment_three.set_normal_texture(unfocused)	
#	button_one.set_normal_texture(unfocused)
#	button_two.set_normal_texture(unfocused)
#	button_three.set_normal_texture(unfocused)	
	
	
#func set_icons():
#	icon_one.set_texture(equipment[0].icon)
#	icon_two.set_texture(equipment[1].icon)
#	icon_three.set_texture(equipment[2].icon)


#func set_titles():
#	title_one.bbcode_text = equipment[0].name
#	title_two.bbcode_text = equipment[1].name
#	title_three.bbcode_text = equipment[2].name


#func set_descriptions():
#	for i in equipment.size():
#		var current_equipment = equipment[i]
#		var description = ""
#
#		for stat in current_equipment.potential_stats:
#			if stat == "damage":
#				description += "dmg: " + str(current_equipment.minimum_damage) + "-" + str(current_equipment.maximum_damage) + " | "
#			elif stat == "crit_rate":
#				description += "crit rate: " + str(current_equipment.crit_rate) + " | "
#			elif stat == "crit_damage":
#				description += "crit dmg: " + str(current_equipment.crit_damage) + " | "
#			elif stat == "health":
#				description += "hp: " + str(current_equipment.health) + " | "
#			elif stat == "damage_reduction":
#				description += "dmg reduction: " + str(current_equipment.damage_reduction) + "% | "
#			elif stat == "movespeed":
#				description += "move speed: " + str(current_equipment.movespeed) + "% | "
#			elif stat == "pickup_bonus":
#				description += "pick-up radius: " + str(current_equipment.pickup_bonus) + "% | "
#
#		if i == 0:
#			description_one.bbcode_text = description
#		elif i == 1:
#			description_two.bbcode_text = description
#		elif i == 2:
#			description_three.bbcode_text = description


func hide_treasure():
	self.visible = false


func _on_EquipmentOne_pressed() -> void:
	emit_signal("treasure_selected", equipment[0])


func _on_EquipmentTwo_pressed() -> void:
	emit_signal("treasure_selected", equipment[1])


func _on_EquipmentThree_pressed() -> void:
	emit_signal("treasure_selected", equipment[2])


func _on_EquipmentOne_mouse_entered() -> void:
	equipment_one.grab_focus()


func _on_EquipmentTwo_mouse_entered() -> void:
	equipment_two.grab_focus()


func _on_EquipmentThree_mouse_entered() -> void:
	equipment_three.grab_focus()


func _on_EquipmentOne_focus_entered() -> void:
	set_default_button_textures()
	equipment_one.set_normal_texture(focused)


func _on_EquipmentTwo_focus_entered() -> void:
	set_default_button_textures()
	equipment_two.set_normal_texture(focused)


func _on_EquipmentThree_focus_entered() -> void:
	set_default_button_textures()
	equipment_three.set_normal_texture(focused)


#func _on_ButtonOne_pressed() -> void:
#	emit_signal("treasure_selected", equipment[0])
#
#
#func _on_ButtonTwo_pressed() -> void:
#	emit_signal("treasure_selected", equipment[1])
#
#
#func _on_ButtonThree_pressed() -> void:
#	emit_signal("treasure_selected", equipment[2])
#
#
#func _on_ButtonOne_mouse_entered() -> void:
#	button_one.grab_focus()
#
#
#func _on_ButtonTwo_mouse_entered() -> void:
#	button_two.grab_focus()
#
#
#func _on_ButtonThree_mouse_entered() -> void:
#	button_three.grab_focus()
#
#
#func _on_ButtonOne_focus_entered() -> void:
#	unfocus_buttons()
#	button_one.set_normal_texture(focused)
#
#
#func _on_ButtonTwo_focus_entered() -> void:
#	unfocus_buttons()
#	button_two.set_normal_texture(focused)
#
#
#func _on_ButtonThree_focus_entered() -> void:
#	unfocus_buttons()
#	button_three.set_normal_texture(focused)






