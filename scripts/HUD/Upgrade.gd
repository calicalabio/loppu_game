extends Node2D

signal upgrade_selected(upgrade)
signal reroll_selected()

onready var unfocused = preload("res://assets/img/upgrade/btn_skill_unfocused.png")
onready var focused = preload("res://assets/img/upgrade/btn_skill_focused.png")
onready var reroll_unfocused = preload("res://assets/img/upgrade/btn_reroll_unfocused.png")
onready var reroll_focused = preload("res://assets/img/upgrade/btn_reroll_focused.png")

onready var reroll_button = $Panel/RerollButton
onready var reroll_cost_label = $Panel/RerollButton/RerollCost

onready var skill_one = $Panel/SkillOne
onready var skill_two = $Panel/SkillTwo
onready var skill_three = $Panel/SkillThree
onready var skill_four = $Panel/SkillFour

var upgrades : Array = []


func show_upgrades(_upgrades : Array, reroll_cost : int):
	upgrades = _upgrades	
	reroll_cost_label.text = str(reroll_cost)
	
	skill_two.release_focus()
	skill_three.release_focus()
	skill_four.release_focus()	
	reroll_button.release_focus()
	
	set_default_button_textures()
	
	skill_one.grab_focus()	
	skill_one.set_normal_texture(focused)	
	
	add_filler_upgrades()
	
	skill_one.setup(upgrades[0])
	skill_two.setup(upgrades[1])
	skill_three.setup(upgrades[2])
	skill_four.setup(upgrades[3])

	self.visible = true
	
	
func set_default_button_textures():
	skill_one.set_normal_texture(unfocused)
	skill_two.set_normal_texture(unfocused)
	skill_three.set_normal_texture(unfocused)
	skill_four.set_normal_texture(unfocused)
	reroll_button.set_normal_texture(reroll_unfocused)
	

func add_filler_upgrades():
	if upgrades.size() < 4:
		var filler_count = 4 - upgrades.size()
		
		for i in filler_count:
			upgrades.append(get_currency_upgrade())
	
	
func get_currency_upgrade() -> Upgrade:
	var upgrade = Upgrade.new()	
	upgrade.weapon_name = "Currency"
	upgrade.weapon_icon = load("res://assets/img/skill_magic_missile.png")	
	upgrade.type = "currency"
	upgrade.description = "Gain 10 coins"
	
	return upgrade
	

func close_upgrades():
	self.visible = false


func _on_SkillOne_pressed() -> void:
	emit_signal("upgrade_selected", upgrades[0])


func _on_SkillTwo_pressed() -> void:
	emit_signal("upgrade_selected", upgrades[1])


func _on_SkillThree_pressed() -> void:
	emit_signal("upgrade_selected", upgrades[2])


func _on_SkillFour_pressed() -> void:
	emit_signal("upgrade_selected", upgrades[3])


func _on_SkillOne_mouse_entered() -> void:
	skill_one.grab_focus()


func _on_SkillTwo_mouse_entered() -> void:
	skill_two.grab_focus()


func _on_SkillThree_mouse_entered() -> void:
	skill_three.grab_focus()


func _on_SkillFour_mouse_entered() -> void:
	skill_four.grab_focus()


func _on_SkillOne_focus_entered() -> void:
	set_default_button_textures()
	skill_one.set_normal_texture(focused)


func _on_SkillTwo_focus_entered() -> void:
	set_default_button_textures()
	skill_two.set_normal_texture(focused)


func _on_SkillThree_focus_entered() -> void:
	set_default_button_textures()
	skill_three.set_normal_texture(focused)


func _on_SkillFour_focus_entered() -> void:
	set_default_button_textures()
	skill_four.set_normal_texture(focused)



func _on_RerollButton_pressed() -> void:
	emit_signal("reroll_selected")
	
	
func _on_RerollButton_mouse_entered() -> void:
	reroll_button.grab_focus()


func _on_RerollButton_focus_entered() -> void:
	set_default_button_textures()
	reroll_button.set_normal_texture(reroll_focused)












