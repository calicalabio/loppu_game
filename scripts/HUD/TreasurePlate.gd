extends TextureButton

onready var icon = $Icon
onready var title = $Title
onready var description = $Description

var equipment : Equipment = null


func setup(_equipment : Equipment):
	equipment = _equipment
	
	set_icon()
	set_title()
	set_description()
	

func set_icon():
	icon.set_texture(equipment.icon)
	

func set_title():
	title.bbcode_text = equipment.name
	

func set_description():
	var description_text = ""
		
	for stat in equipment.potential_stats:
		if stat == "damage":
			description_text += "dmg: " + str(equipment.minimum_damage) + "-" + str(equipment.maximum_damage) + " | "
		elif stat == "crit_rate":
			description_text += "crit rate: " + str(equipment.crit_rate) + " | "
		elif stat == "crit_damage":
			description_text += "crit dmg: " + str(equipment.crit_damage) + " | "
		elif stat == "health":
			description_text += "hp: " + str(equipment.health) + " | "
		elif stat == "damage_reduction":
			description_text += "dmg reduction: " + str(equipment.damage_reduction) + "% | "
		elif stat == "movespeed":
			description_text += "move speed: " + str(equipment.movespeed) + "% | "
		elif stat == "pickup_bonus":
			description_text += "pick-up radius: " + str(equipment.pickup_bonus) + "% | "	

	description.bbcode_text = description_text
