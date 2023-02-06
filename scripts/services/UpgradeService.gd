class_name UpgradeService


func generate_upgrades(weapons : Array) -> Array:
	var upgrades = []
	
	for weapon in weapons:
		var upgrade = generate_upgrade_for_weapon(weapon)
		upgrades.append(upgrade)
				
	return upgrades


func generate_upgrade_for_weapon(weapon : Weapon) -> Upgrade:
	if weapon.is_equipped:
		return generate_stat_upgrade(weapon)
	else:
		return generate_equip_upgrade(weapon)


func generate_stat_upgrade(weapon : Weapon) -> Upgrade:
	var upgrade = Upgrade.new()
	
	upgrade.weapon_name = weapon.name
	upgrade.weapon_icon = weapon.icon
	upgrade.weapon_frame = weapon.next_frame
	upgrade.weapon_level = weapon.weapon_level + 1
	upgrade.type = "stat"
	upgrade.stat = weapon.upgrades[weapon.weapon_level + 1]
#	upgrade.stat_boost_amount = weapon.possible_stat_upgrades[upgrade.stat]
#	upgrade.old_stat_value = weapon.get_stat_value(upgrade.stat)
#	upgrade.new_stat_value = calculate_new_stat_value(upgrade.stat, weapon, upgrade.stat_boost_amount)
	upgrade.is_max = (weapon.weapon_level + 1) == weapon.upgrades.size()	
	upgrade.description = weapon.description if not weapon.is_equipped else generate_stat_upgrade_description(upgrade)	
	upgrade.detailed_description = generate_detailed_description(upgrade, weapon)
	
	return upgrade
	
			
func generate_equip_upgrade(weapon : Weapon) -> Upgrade:
	var upgrade = Upgrade.new()
	
	upgrade.weapon_name = weapon.name
	upgrade.weapon_icon = weapon.icon
	upgrade.weapon_frame = weapon.frame
	upgrade.type = "equip"
	upgrade.description = weapon.description
	
	return upgrade	


func get_random_stat(weapon : Weapon, vetoed_upgrades : Dictionary) -> String:		
	var potential_stats = weapon.possible_stat_upgrades.keys()
	
	if vetoed_upgrades.has(weapon.name):
		for vetoed_stat in vetoed_upgrades[weapon.name]:
			potential_stats.erase(vetoed_stat)
	
	var random_stat_index = Global.rng.randi_range(0, potential_stats.size() - 1)
	return potential_stats[random_stat_index]


func calculate_new_stat_value(stat : String, weapon : Weapon, stat_boost_amount):
	if stat == "projectile_count":		
		return weapon.base_projectile_count + weapon.projectile_count_bonus + stat_boost_amount 
	elif stat == "penetration":
		return weapon.base_penetration + weapon.penetration_bonus + stat_boost_amount
	elif stat == "damage":
		return weapon.base_damage + weapon.damage_bonus + stat_boost_amount
#		return weapon.base_damage + (weapon.base_damage * ((weapon.damage_bonus + stat_boost_amount) / 100.0))
	elif stat == "crit_rate":
		return weapon.base_crit_rate + weapon.crit_rate_bonus + stat_boost_amount
	elif stat == "crit_damage":
		return weapon.base_crit_damage + weapon.crit_damage_bonus + stat_boost_amount
	elif stat == "cooldown":
		return weapon.base_cooldown - weapon.cooldown_bonus - stat_boost_amount
#		return weapon.base_cooldown - (weapon.base_cooldown * ((weapon.cooldown_bonus + stat_boost_amount) / 100.0))
	elif stat == "duration":
		return weapon.base_duration + weapon.duration_bonus + stat_boost_amount
#		return weapon.base_duration + (weapon.base_duration * ((weapon.duration_bonus + stat_boost_amount) / 100.0))
	elif stat == "fire_rate":
		return weapon.base_fire_rate - weapon.fire_rate_bonus - stat_boost_amount
#		return weapon.base_fire_rate - (weapon.base_fire_rate * ((weapon.fire_rate_bonus + stat_boost_amount) / 100.0))
	elif stat == "summon_count":
		return weapon.base_summon_count + weapon.summon_count_bonus + stat_boost_amount	
	elif stat == "aoe":
		return weapon.base_aoe + weapon.aoe_bonus + stat_boost_amount
#		return weapon.base_aoe + (weapon.base_aoe * ((weapon.aoe_bonus + stat_boost_amount) / 100.0))
	elif stat == "stun_duration":
		return weapon.base_stun_duration + weapon.stun_duration_bonus + stat_boost_amount
#		return weapon.base_stun_duration + (weapon.base_stun_duration * ((weapon.stun_duration_bonus + stat_boost_amount) / 100.0))
	elif stat == "projectile_speed":
		return weapon.base_projectile_speed + weapon.projectile_speed_bonus + stat_boost_amount
#		return weapon.base_projectile_speed + (weapon.base_projectile_speed * ((weapon.projectile_speed_bonus + stat_boost_amount) / 100.0))
	

func generate_stat_upgrade_description(upgrade : Upgrade) -> String:
	var description = ""
	
	for key in upgrade.stat:
		description += key + " + "		
	
	return description.substr(0, description.length() - 3)


func generate_detailed_description(upgrade : Upgrade, weapon : Weapon) -> String:
	var detailed_description = ""
	
	for key in upgrade.stat:
		if key == "projectile_count":		
			detailed_description += "projectile count "
		elif key == "penetration":
			detailed_description += "penetration "
		elif key == "damage":
			detailed_description += "damage "
		elif key == "crit_rate":
			detailed_description += "crit rate "
		elif key == "crit_damage":
			detailed_description += "crit damage "
		elif key == "cooldown":
			detailed_description += "cooldown "
		elif key == "duration":
			detailed_description += "duration "
		elif key == "fire_rate":
			detailed_description += "fire rate "
		elif key == "summon_count":
			detailed_description += "summon count "
		elif key == "aoe":
			detailed_description += "aoe "
		elif key == "stun_duration":
			detailed_description += "stun duration "
		elif key == "projectile_speed":
			detailed_description += "projectile speed"
	
	return detailed_description


#func old_generate_stat_upgrade_description(upgrade : Upgrade, weapon : Weapon) -> String:	
#	var difference_symbol = " > "
#	var stat_name = upgrade.stat.replace("_", " ")
#	var max_text = " (max)" if upgrade.is_max else ""
#
#	if upgrade.stat == "damage":
#		var old_value = str(weapon.min_damage) + "-" + str(weapon.max_damage)
#		var new_value = str(weapon.damage_levels[weapon.damage_level + 1][0]) + "-" + str(weapon.damage_levels[weapon.damage_level + 1][1])
#		return "Increase damage.\n[color=#ffb967]" + old_value + "\n>\n " + new_value + max_text + "[/color]"
#	elif upgrade.stat == "projectile_count":
#		if upgrade.weapon_name == "Chain Lightning":
#			return "Bounce more times.\n[color=#ffb967]" + str(int(upgrade.old_stat_value)) + difference_symbol + str(int(upgrade.new_stat_value)) + max_text + "[/color]"
#		elif upgrade.weapon_name == "Disco Ball":
#			return "Zap more enemies at a time.\n[color=#ffb967]" + str(int(upgrade.old_stat_value)) + difference_symbol + str(int(upgrade.new_stat_value))  + max_text + "[/color]"
#		else:
#			return "Increase projectiles count.\n[color=#ffb967]" + str(int(upgrade.old_stat_value)) + difference_symbol + str(int(upgrade.new_stat_value)) + max_text + "[/color]"
#	elif upgrade.stat == "summon_count":
#		if upgrade.weapon_name == "Hydra":
#			return "Increase the number of hydras by " + str(upgrade.stat_boost_amount) + ".\n[color=#ffb967]" + str(int(upgrade.old_stat_value)) + difference_symbol + str(int(upgrade.new_stat_value)) + max_text + "[/color]"
#		elif upgrade.weapon_name == "Chain Lightning":
#			return "Lightning forks 1 more time.\n[color=#ffb967]" + str(int(upgrade.old_stat_value)) + difference_symbol + str(int(upgrade.new_stat_value)) + max_text + "[/color]"
#		else:
#			return "Increase summons by " + str(upgrade.stat_boost_amount) + ".\n[color=#ffb967]" + str(int(upgrade.old_stat_value)) + difference_symbol + str(int(upgrade.new_stat_value)) + max_text + "[/color]"
#	elif upgrade.stat == "penetration":
#		return "Increase weapon penetration by " + str(upgrade.stat_boost_amount) + ".\n[color=#ffb967]" + str(int(upgrade.old_stat_value)) + difference_symbol + str(int(upgrade.new_stat_value)) + max_text + "[/color]"
#	elif upgrade.stat == "cooldown" or upgrade.stat == "fire_rate":
##		var stat_boost = str(int(upgrade.stat_boost_amount)) + "%"
##		var stat_value_change = str(upgrade.old_stat_value) + " sec" + difference_symbol + str(upgrade.new_stat_value) + " sec"
##		return "Decrease " + str("cooldown" if upgrade.stat == "cooldown" else "fire rate") + " by " + stat_boost + ".\n[color=#ffb967]" + stat_value_change + "[/color]"
#		var stat_value_change = str(upgrade.old_stat_value) + difference_symbol + str(upgrade.new_stat_value)
#		return "Decrease " + stat_name + ".\n[color=#ffb967]" + stat_value_change + max_text + "[/color]"
#	elif upgrade.stat == "crit_rate" or upgrade.stat == "crit_damage":
##		var description = "Increase " + ("CRIT RATE" if upgrade.stat == "crit_rate" else "CRIT DAMAGE") + " by " + str(int(upgrade.stat_boost_amount)) + "%."
##		var difference = str(int(upgrade.old_stat_value)) + "%" + difference_symbol + str(int(upgrade.new_stat_value)) + "%"
##		return description + "\n[color=#ffb967]" + difference + "[/color]"
#		var difference = str(int(upgrade.old_stat_value)) + "%" + difference_symbol + str(int(upgrade.new_stat_value)) + "%"
#		return "Increase " + ("CRIT RATE" if upgrade.stat == "crit_rate" else "CRIT DAMAGE") + "." + "\n[color=#ffb967]" + difference + max_text + "[/color]"
#	else:
#		#var stat_boost = str(int(upgrade.stat_boost_amount)) + "%"
#		var stat_value_change = str(upgrade.old_stat_value) + difference_symbol + str(upgrade.new_stat_value)
#		#return "Increase " + stat_name + "by " + stat_boost + ".\n[color=#ffb967]" + stat_value_change + "[/color]"
#		return "Increase " + stat_name + ".\n[color=#ffb967]" + stat_value_change + max_text + "[/color]"

