#ver 0.08g
extends Node2D

onready var upgrade_service = UpgradeService.new()
onready var game_service = GameService.new()
onready var equipment_service = EquipmentService.new()

#var rng = RandomNumberGenerator.new()
var game_level : int = 1
var game_duration : float = 0
var is_level_complete : bool = false
var is_game_over : bool = false
#var rerolls_available : int = 0
var reroll_cost : int = 5
var enemies_killed : int = 0
var max_weapon_limit : int = 4
var equipped_weapons_count : int = 0
var currency_collected : int = 0

var player : Node = null
var enemies : Node = null
var weapons : Node = null
var drops : Node = null
var HUD : Node = null
var floating_numbers : Node = null

var equipped_helmet : Equipment = null
var equipped_weapon : Equipment = null
var equipped_off_hand : Equipment = null
var equipped_chest : Equipment = null

func _ready() -> void:
	Global.rng.randomize()

	player = $YSort/Player
	enemies = $YSort/Enemies
	floating_numbers = $FloatingNumbers
	weapons = $YSort/Weapons
	drops = $YSort/Drops
	HUD = $HUD
	
	$Treadmill.player = player
	enemies.player = player
	weapons.player = player
	weapons.enemies = enemies	
	
	player.connect("player_health_updated", self, "handle_player_health")
	player.connect("player_hearts_updated", self, "handle_player_hearts")
	player.connect("player_gained_exp", self, "handle_exp_gain")
	player.connect("player_levelled_up", self, "handle_level_up")
	player.connect("player_died", self, "show_death_message")
	player.connect("ready_for_results", self, "show_game_results")
	player.connect("currency_aquired", self, "handle_currency_gain")
		
	weapons.connect("equipped_weapons_updated", self, "handle_updated_weapons")
	weapons.connect("weapon_fired", self, "handle_weapon_fired")
	
	drops.connect("player_entered_door", self, "initialise_next_level")
	drops.connect("player_opened_treasure", self, "handle_opened_treasure")
	
	enemies.connect("enemy_spawned", self, "handle_spawned_enemy")
	enemies.connect("enemy_took_damage", self, "handle_damaged_enemy")
	enemies.connect("enemy_died", self, "handle_dead_enemy")
	enemies.connect("boss_died", self, "handle_dead_boss")
	
	HUD.connect("reset_button_pressed", self, "restart_game")
	HUD.connect("upgrade_selected", self, "handle_upgrade_selection")
	HUD.connect("treasure_selected", self, "equip_treasure")
	HUD.connect("reroll_selected", self, "reroll_upgrades")
	HUD.connect("round_manually_ended", self, "exit_to_menu")
	HUD.connect("round_finished", self, "save_and_exit_to_menu")
	HUD.update_weapon_bar(weapons.get_equipped_weapons())
	
	HUD.update_total_currency(Global.currency)
	HUD.update_hearts(player.player_hearts, player.player_max_hearts)
	
	generate_default_equipment()
	#present_initial_weapon_choice()
		
		
func _process(delta: float) -> void:
	if not is_level_complete and not is_game_over:
		game_duration += delta
		enemies.update_current_wave(game_duration)
		HUD.update_time(game_service.format_time_string(game_duration))
		HUD.update_fps(Engine.get_frames_per_second())
			

func generate_default_equipment():
	if player.player_class == "Swords":
		equip_treasure(equipment_service.generate_equipment_default("res://scripts/equipment/definitions/ShortSwordDefinition.gd"))
		equip_treasure(equipment_service.generate_equipment_default("res://scripts/equipment/definitions/WoodenShieldDefinition.gd"))
	
	player.player_health = player.player_max_health
	HUD.update_hp_bar(player.player_health, player.player_max_health)
	

func handle_spawned_enemy():
	HUD.update_enemy_counter(1)


func handle_damaged_enemy(damage : float, enemy_coordinates : Vector2, is_crit : bool):
	floating_numbers.spawn_floating_number(damage, enemy_coordinates, is_crit)


func handle_dead_enemy(enemy_location : Vector2):
	enemies_killed += 1
	HUD.update_kills(enemies_killed)
	drops.try_drop_item(enemy_location, player)
	HUD.update_enemy_counter(-1)
	
	if game_duration > 300.0 and enemies.get_enemy_count() <= 0:
		conclude_level()


func handle_dead_boss(boss_location : Vector2):
	drops.spawn_chest(boss_location)


func present_initial_weapon_choice():
	HUD.upgrade_pause()
	var weapon_choices = weapons.get_random_weapons(4, 0)
	HUD.show_upgrades(upgrade_service.generate_upgrades(weapon_choices), reroll_cost)
	pass


func handle_player_health(new_value : float, max_health : float):
	print("player hp: " + str(new_value))
	HUD.update_hp_bar(new_value, max_health)
	

func handle_player_hearts(new_value : float, max_hearts : float):
	print("player hearts: " + str(new_value))
	HUD.update_hearts(new_value, max_hearts)
	
	
func handle_exp_gain(current_exp : float, max_exp : float):
	HUD.update_exp_bar(current_exp, max_exp)	
	
	
func handle_level_up(player_level):
	if not is_game_over:
#		if player_level % 5 == 0:
#			rerolls_available += 1
		
		HUD.update_player_level(player_level)
		HUD.upgrade_pause()		
		HUD.show_upgrades(roll_upgrades(), reroll_cost)


func handle_currency_gain(worth : int):
	currency_collected += worth
	HUD.update_currency(currency_collected)
	

func roll_upgrades() -> Array:
	var unequipped_weapons = weapons.get_unequipped_weapons()
	var equipped_weapons = weapons.get_equipped_weapons()
	var upgradeable_weapons = weapons.get_upgradeable_weapons()
	var upgrade_distribution = roll_weapon_upgrade_distribution(unequipped_weapons.size(), equipped_weapons.size(), upgradeable_weapons.size())
	var selected_weapons = weapons.get_random_weapons(upgrade_distribution[0], upgrade_distribution[1])
	
	return upgrade_service.generate_upgrades(selected_weapons)


func roll_weapon_upgrade_distribution(unequipped_weapons_count : int, equipped_weapons_count : int, upgradeable_weapons_count : int) -> Array:
	var new_weapons = 0
	var new_upgrades = 0
	var currency_boosts = 0
	
	if equipped_weapons_count >= max_weapon_limit:
		unequipped_weapons_count = 0
	
	if (unequipped_weapons_count + upgradeable_weapons_count) < 4: #if not enough upgrades to fill 4 slots, add currency
		new_weapons = unequipped_weapons_count
		new_upgrades = upgradeable_weapons_count
		currency_boosts = 4 - (unequipped_weapons_count + upgradeable_weapons_count)	
	else:
		new_weapons = unequipped_weapons_count
		new_upgrades = upgradeable_weapons_count
		
		while (new_weapons + new_upgrades) > 4:
			if new_weapons > new_upgrades:
				new_weapons -= 1
			elif new_upgrades > new_weapons:
				new_upgrades -= 1
			else:			
				var roll = Global.rng.randi_range(0, 1)
							
				if roll == 0 and new_weapons > 0:				
					new_weapons -= 1
				elif roll == 1 and new_upgrades > 0:
					new_upgrades -= 1			
	
	return [new_weapons, new_upgrades, currency_boosts] 
	

func old_roll_weapon_upgrade_distribution(unequipped_weapons_count : int, equipped_weapons_count : int, upgradeable_weapons_count : int) -> Array:
	var new_weapons = 0
	var new_upgrades = 0
	var currency_boosts = 0
	
	if equipped_weapons_count >= max_weapon_limit:
		unequipped_weapons_count = 0
	
	if (unequipped_weapons_count + upgradeable_weapons_count) < 3: #if not enough upgrades to fill 3 slots, add currency
		new_weapons = unequipped_weapons_count
		new_upgrades = upgradeable_weapons_count
		currency_boosts = 3 - (unequipped_weapons_count + upgradeable_weapons_count)		
	else: #if enough upgrades to fill 3
		if unequipped_weapons_count == 0:
			new_weapons = 0
			new_upgrades = 3
		elif upgradeable_weapons_count == 0:
			new_weapons = 3
			new_upgrades = 0
		elif unequipped_weapons_count == 1: 
			new_weapons = 1
			new_upgrades = 2
		elif upgradeable_weapons_count == 1: #if only one weapon is upgradeable, give chance to present 3 weapons
			if unequipped_weapons_count >= 3:
				var roll = Global.rng.randi_range(1, 100)
				new_weapons = 3 if roll <= 33 else 2
				new_upgrades = 0 if roll <= 33 else 1
			else:
				new_weapons = 2
				new_upgrades = 1
		elif unequipped_weapons_count == 2 or upgradeable_weapons_count == 2:
			var roll = Global.rng.randi_range(0, 1)
			
			if roll == 0:
				new_weapons = 1
				new_upgrades = 2
			else:
				new_weapons = 2
				new_upgrades = 1
		else: #if both unequipped weapons > 3 and upgradeable weapons > 3
			var roll = Global.rng.randi_range(1, 100)
			
			if roll <= 15:
				new_weapons = 3
				new_upgrades = 0
			elif roll <= 30:
				new_weapons = 0
				new_upgrades = 3
			elif roll <= 65:
				new_weapons = 2
				new_upgrades = 1
			elif roll <= 100:
				new_weapons = 1
				new_upgrades = 2
	
	return [new_weapons, new_upgrades, currency_boosts] 


func handle_upgrade_selection(upgrade : Upgrade):
	if upgrade.type == "stat":
		weapons.apply_upgrade_to_weapon(upgrade)
	elif upgrade.type == "currency":
		handle_currency_gain(25)
	else:
		weapons.equip_weapon(upgrade.weapon_name)
		
	HUD.hide_upgrades()
	HUD.upgrade_unpause()


func reroll_upgrades():
#	rerolls_available -= 1
	if currency_collected >= reroll_cost:
		currency_collected -= reroll_cost
		HUD.update_currency(currency_collected)
		reroll_cost *= 2
		HUD.show_upgrades(roll_upgrades(), reroll_cost)
	

func handle_updated_weapons(number_of_equipped_weapons : int):
	equipped_weapons_count = number_of_equipped_weapons
	HUD.update_weapon_bar(weapons.get_equipped_weapons())


func handle_weapon_fired(weapon_name : String, cooldown_time : float):
	var equipped_weapons = weapons.get_equipped_weapons()
	
	for i in equipped_weapons.size():
		if equipped_weapons[i].name == weapon_name:
			HUD.start_cooldown_indicator(i + 1, cooldown_time)	


func handle_opened_treasure():
	HUD.upgrade_pause()		
	HUD.show_treasure(equipment_service.generate_random_equipment(3))


func equip_treasure(equipment : Equipment):
	if equipment.type == "helmet":
		if not equipped_helmet == null:
			unequip(equipped_helmet)
			
		equip(equipment)
		equipped_helmet = equipment
		player.helmet_name = equipment.name
		player.helmet_sprite.visible = true
		
	elif equipment.type == "weapon":
		if not equipped_weapon == null:
			unequip(equipped_weapon)
			
		equip(equipment)
		equipped_weapon = equipment
		player.weapon_name = equipment.name
		player.weapon_sprite.visible = true
		
	elif equipment.type == "off_hand":
		if not equipped_off_hand == null:
			unequip(equipped_off_hand)
			
		equip(equipment)
		equipped_off_hand = equipment
		player.off_hand_name = equipment.name
		player.off_hand_sprite.visible = true
		
	elif equipment.type == "chest":
		if not equipped_chest == null:
			unequip(equipped_chest)
			
		equip(equipment)
		equipped_chest = equipment
		player.chest_name = equipment.name
		player.chest_sprite.visible = true
	
	if player.player_health > player.player_max_health:
		player.player_health = player.player_max_health
		
	player.sync_equipment_animations()
	HUD.hide_treasure()
	HUD.upgrade_unpause()
	update_equipment_hud()
	HUD.update_hp_bar(player.player_health, player.player_max_health)
	

func unequip(equipment : Equipment):
	for stat in equipment.potential_stats:
		if stat == "health":
			player.player_max_health -= float(equipment.health)
		elif stat == "damage_reduction":
			player.damage_reduction -= equipment.damage_reduction
		elif stat == "movespeed":
			player.player_speed_bonus -= equipment.movespeed
		

func equip(equipment : Equipment):
	for stat in equipment.potential_stats:
		if stat == "damage":
			replace_main_weapon(equipment)
		elif stat == "health":
			player.player_max_health += float(equipment.health)
		elif stat == "damage_reduction":
			player.damage_reduction += equipment.damage_reduction
		elif stat == "movespeed":
			player.player_speed_bonus += equipment.movespeed	
		

func replace_main_weapon(equipment : Equipment):	
	var equipped_weapon = weapons.class_weapons[equipment.name]
	
	if equipped_weapon.name == equipment.name:		
		equipped_weapon.min_damage = float(equipment.minimum_damage)
		equipped_weapon.max_damage = float(equipment.maximum_damage)
		equipped_weapon.crit_rate = float(equipment.crit_rate)
		equipped_weapon.crit_damage = float(equipment.crit_damage)
	else:
		weapons.switch_class_weapon(equipment)
	

func update_equipment_hud():
	var equipment = {}
	
	if not equipped_helmet == null:
		equipment["helmet"] = equipped_helmet
		
	if not equipped_weapon == null:
		equipment["weapon"] = equipped_weapon
		
	if not equipped_off_hand == null:
		equipment["off_hand"] = equipped_off_hand
		
	if not equipped_chest == null:
		equipment["chest"] = equipped_chest	
	
	HUD.update_equipment_icons(equipment)
	

func conclude_level():
	is_level_complete = true
	drops.spawn_door(player.global_position)


func initialise_next_level():
	game_level += 1		
		
		
func show_death_message():
	HUD.show_death_message()
		
		
func show_game_results():		
	is_game_over = true	
	weapons.stop_timers()
	HUD.show_results(get_results())


func get_results() -> Dictionary:
	var results = {}
	
	results["level"] = player.player_level
	results["time_survived"] = game_service.format_time_string(game_duration)
	results["enemies_killed"] = enemies_killed
	results["gold"] = currency_collected
	
	return results	


func restart_game():
	get_tree().reload_current_scene()


func exit_to_menu():
	get_tree().change_scene("res://scenes/Menu.tscn")
	#assert(get_tree().change_scene("res://scenes/Menu.tscn") == OK)

func save_and_exit_to_menu():
	Global.currency += currency_collected
	Global.save_game()
	exit_to_menu()
