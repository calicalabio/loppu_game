extends TextureButton

onready var icon = $Icon
onready var frame = $Frame
onready var title = $Title
onready var description = $Description

var upgrade : Upgrade = null


func setup(_upgrade : Upgrade):
	upgrade = _upgrade
	
	set_frame()
	set_icon()
	set_title()
	set_description()
	

func set_frame():
	frame.set_texture(upgrade.weapon_icon)


func set_icon():	
	icon.set_texture(upgrade.weapon_icon)
	
	
func set_title():
	title.bbcode_text = upgrade.weapon_name.to_lower()


func set_description():
	description.bbcode_text = upgrade.description.to_lower()
