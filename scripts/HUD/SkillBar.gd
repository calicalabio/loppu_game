extends Node2D

onready var exp_bar = $EXPBar/EXPProgress


func update_exp_bar(current_exp : float, max_exp : float):
	exp_bar.max_value = max_exp
	exp_bar.value = current_exp


func update_weapon_icons(weapons : Array):	
	for i in weapons.size():
		var skill = find_node("Skill" + str(i + 1))
		skill.update_weapon_icons(weapons[i])


func start_cooldown_indicator(skill_number : int, cooldown_time : float):
	print("fired weapon no. " +  str(skill_number))
	var skill = find_node("Skill" + str(skill_number))
	skill.start_cooldown_indicator(cooldown_time)
