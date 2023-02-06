extends Node2D

signal equipped_weapons_updated(equipped_weapon_count)
signal weapon_fired(weapon_name, cooldown_time)

onready var weapon_pool : Node = $WeaponPool

onready var skill_portrait_1 = preload("res://assets/img/skills/skill_01.png")
onready var skill_portrait_2 = preload("res://assets/img/skills/skill_02.png")
onready var skill_portrait_3 = preload("res://assets/img/skills/skill_03.png")
onready var skill_portrait_4 = preload("res://assets/img/skills/skill_04.png")
onready var skill_portrait_5 = preload("res://assets/img/skills/skill_05.png")
onready var skill_portrait_6 = preload("res://assets/img/skills/skill_06.png")
onready var skill_portrait_7 = preload("res://assets/img/skills/skill_07.png")
onready var skill_portrait_8 = preload("res://assets/img/skills/skill_08.png")
onready var skill_portrait_9 = preload("res://assets/img/skills/skill_09.png")

var short_sword_base = ShortSwordBase.new()

var missile_base = MissileBase.new()
var sawblade_base = SawBladeBase.new()
var hydra_base = HydraBase.new()
var meteor_base = MeteorBase.new()
var disco_ball_base = DiscoBallBase.new()
var chain_lightning_base = ChainLightningBase.new()
var impale_base = ImpaleBase.new()
var boomerang_base = BoomerangBase.new()
var bingling_base = BinglingBase.new()
var tesla_coil_base = TeslaCoilBase.new()
var frozen_orb_base = FrozenOrbBase.new()

var weapons : Dictionary = {}
var class_weapons : Dictionary = {}
var number_of_equipped_weapons : int = 0
var player : Node = null
var enemies : Node = null

var global_strength_bonus = 0.0
var global_cooldown_bonus = 0.0
var global_projectile_speed_bonus = 0.0
var global_aoe_bonus
var global_projectile_count_bonus = 0


func _ready() -> void:	
	weapons = get_all_base_weapons()
	class_weapons = get_all_class_weapons()
	weapon_pool.initialise_weapon_pool(weapons)
	#probably should connect all the weapon timers in a loop
	$AutoEquipTimer.connect("timeout", self, "auto_equip")
	$MissileTimer.connect("timeout", self, "fire_weapon", ["Magic Missile"])	
	$SawBladeTimer.connect("timeout", self, "fire_weapon", ["Saw Blade"])
	$HydraTimer.connect("timeout", self, "fire_weapon", ["Hydra"])
	$MeteorTimer.connect("timeout", self, "fire_weapon", ["Meteor"])
	$ChainLightningTimer.connect("timeout", self, "fire_weapon", ["Chain Lightning"])
	$ImpaleTimer.connect("timeout", self, "fire_weapon", ["Impale"])
	$BoomerangTimer.connect("timeout", self, "fire_weapon", ["Boomerang"])
	$BinglingTimer.connect("timeout", self, "fire_weapon", ["Bingling"])
	$TeslaCoilTimer.connect("timeout", self, "fire_weapon", ["Tesla Coil"])
	$FrozenOrbTimer.connect("timeout", self, "fire_weapon", ["Frozen Orb"])
	$ShortSwordTimer.connect("timeout", self, "fire_weapon", ["Short Sword"])
	
	$AutoEquipTimer.start()
	

func get_all_base_weapons() -> Dictionary:
	return {
		"Magic Missile" : missile_base,
		"Saw Blade": sawblade_base,
		"Hydra": hydra_base,
#		"Meteor" : meteor_base,
		"Disco Ball" : disco_ball_base,
		"Chain Lightning" : chain_lightning_base,
		"Impale" : impale_base,
		"Boomerang" : boomerang_base,
		"Bingling" : bingling_base,
		"Tesla Coil" : tesla_coil_base,
		"Frozen Orb" : frozen_orb_base
	}


func get_all_class_weapons() -> Dictionary:
	return {
		"Short Sword" : short_sword_base
	}


func get_equipped_class_weapon_name() -> String:
	for key in class_weapons:
		if class_weapons[key].is_equipped:
			return key
	
	return "couldn't find equipped class weapon"
	

func switch_class_weapon(equipment : Equipment):
	var current_class_weapon = class_weapons[get_equipped_class_weapon_name()]
	current_class_weapon.is_eqipped = false
	var timer = get_node(current_class_weapon.timer_name)
	timer.stop()
	equip_weapon(equipment.name)
	

func auto_equip():
	if player.player_class == "Swords":
		equip_weapon("Short Sword")
		
#	equip_weapon("Magic Missile")
#	equip_weapon("Saw Blade")
#	equip_weapon("Hydra")
#	equip_weapon("Meteor")
#	equip_weapon("Disco Ball")
#	equip_weapon("Chain Lightning")
#	equip_weapon("Impale")
#	equip_weapon("Boomerang")
#	equip_weapon("Tesla Coil")
#	equip_weapon("Frozen Orb")
	pass


func stop_timers():
	#should probably just get all timers and loop
	$ShortSwordTimer.stop()
	$MissileTimer.stop()
	$SawBladeTimer.stop()
	$HydraTimer.stop()
	$MeteorTimer.stop()
	$ChainLightningTimer.stop()
	$ImpaleTimer.stop()
	$BoomerangTimer.stop()
	$BinglingTimer.stop()
	$TeslaCoilTimer.stop()
	$FrozenOrbTimer.stop()
	

func equip_weapon(weapon_name : String):
	var weapon = weapons[weapon_name] if weapons.has(weapon_name) else class_weapons[weapon_name]
	weapon.is_equipped = true
	var timer = get_node(weapon.timer_name)
	
	if not timer == null:
		timer.start()
	
	if not weapon.is_class_weapon:
		number_of_equipped_weapons += 1
		weapon.pickup_order = number_of_equipped_weapons	
		emit_signal("equipped_weapons_updated", number_of_equipped_weapons)
	
	if weapon_name == "Disco Ball":
		spawn_disco_ball()
	else:
		fire_weapon(weapon_name)	


func fire_weapon(weapon_name : String):
	var weapon = weapons[weapon_name] if weapons.has(weapon_name) else class_weapons[weapon_name]
	var weapon_timer = get_node(weapon.timer_name)
	var weapon_function = "spawn_" + weapon.code_name
	
	if not weapon_timer.wait_time == weapon.cooldown:
		weapon_timer.wait_time = weapon.cooldown	
		
	if not weapon.is_class_weapon:
		emit_signal("weapon_fired", weapon_name, weapon_timer.wait_time)
		
	if weapon_name == "Hydra":		
		call(weapon_function, null, Vector2.ZERO, false, 0)
	elif weapon_name == "Chain Lightning":
		call(weapon_function, player.global_position, null, 0)
	elif weapon_name == "Tesla Coil" or weapon_name == "Frozen Orb" or weapon_name == "Short Sword" or weapon_name == "Magic Missile":
		call(weapon_function)
	else:
		call(weapon_function, null)
		var number_of_attacks = global_projectile_count_bonus + weapons[weapon_name].projectile_count	
		
		if number_of_attacks > 1:
			queue_multiple_attacks(number_of_attacks - 1, weapons[weapon_name].fire_rate, weapon_function)	


func queue_multiple_attacks(number_of_attacks : int, delay_between_shots : float, weapon_method : String):
	for i in number_of_attacks:
			var new_fire_rate_timer = Timer.new()
			new_fire_rate_timer.one_shot = true
			new_fire_rate_timer.set_wait_time(float(1 + i) * delay_between_shots)
			new_fire_rate_timer.connect("timeout", self, weapon_method, [new_fire_rate_timer])
			add_child(new_fire_rate_timer)
			new_fire_rate_timer.start()


func get_random_weapons(unequipped_weapons_count : int, equipped_weapons_count : int) -> Array:
	var random_weapons = []
		
	var unequipped_weapons = get_unequipped_weapons()
	var upgradeable_weapons = get_upgradeable_weapons()
	
	if unequipped_weapons_count > 0:
		for i in unequipped_weapons_count:
			var random_weapon = get_random_weapon(unequipped_weapons)
			random_weapons.append(random_weapon)
			unequipped_weapons.erase(random_weapon)
		
	if equipped_weapons_count > 0:
		for i in equipped_weapons_count:
			var random_weapon = get_random_weapon(upgradeable_weapons)
			random_weapons.append(random_weapon)
			upgradeable_weapons.erase(random_weapon)
		
	return random_weapons


func get_random_weapon(weapons : Array) -> Weapon:
	var random_weapon_index = Global.rng.randi_range(0, weapons.size() - 1)
	return weapons[random_weapon_index]
		

func get_equipped_weapons() -> Array:
	var equipped_weapons = []
	
	for weapon in weapons.values():
		if weapon.is_equipped:
			equipped_weapons.append(weapon)
	
	if equipped_weapons.size() > 1:
		equipped_weapons.sort_custom(self, "sort_by_pickup_order")	
		
	return equipped_weapons
	

func sort_by_pickup_order(a, b):
	return a.pickup_order < b.pickup_order	


func get_unequipped_weapons() -> Array:
	var unequipped_weapons = []
	
	for weapon in weapons.values():
		if not weapon.is_equipped:
			unequipped_weapons.append(weapon)

	return unequipped_weapons


func get_upgradeable_weapons() -> Array:
	var upgradeable_weapons = []
	
	for weapon in weapons.values():
		if weapon.is_equipped and weapon.weapon_level < weapon.upgrades.size():
			upgradeable_weapons.append(weapon)
	
	return upgradeable_weapons
	

func apply_upgrade_to_weapon(upgrade : Upgrade):
	var weapon_to_upgrade = weapons[upgrade.weapon_name]	
	
	for key in upgrade.stat:
		var stat_value = upgrade.stat[key]
		
		if key == "damage":
			weapon_to_upgrade.min_damage = stat_value[0]
			weapon_to_upgrade.max_damage = stat_value[1]
		elif key == "crit_rate":
			weapon_to_upgrade.crit_rate = stat_value
		elif key == "crit_damage":
			weapon_to_upgrade.crit_damage = stat_value
		elif key == "cooldown":
			weapon_to_upgrade.cooldown = stat_value
		elif key == "projectile_speed":
			weapon_to_upgrade.projectile_speed = stat_value
		elif key == "projectile_count":
			weapon_to_upgrade.projectile_count = stat_value
		elif key == "penetration":
			weapon_to_upgrade.penetration = stat_value
		elif key == "duration":
			weapon_to_upgrade.duration = stat_value
		elif key == "fire_rate":
			weapon_to_upgrade.fire_rate = stat_value
		elif key == "summon_count":
			weapon_to_upgrade.summon_count = stat_value
		elif key == "aoe":
			weapon_to_upgrade.aoe = stat_value
		elif key == "stun_duration":
			weapon_to_upgrade.stun_duration = stat_value
	
	weapon_to_upgrade.weapon_level += 1
	weapon_to_upgrade.frame = self.get("skill_portrait_" + str(weapon_to_upgrade.weapon_level + 1))
	weapon_to_upgrade.next_frame = self.get("skill_portrait_" + str(weapon_to_upgrade.weapon_level + 2))
	emit_signal("equipped_weapons_updated", number_of_equipped_weapons)
	
	if upgrade.weapon_name == "Disco Ball":
		update_disco_ball_stats()


func get_weapon_instance(weapon_name : String) -> Node:
	var weapon = weapons[weapon_name] if weapons.has(weapon_name) else class_weapons[weapon_name]
	return weapon_pool.get_weapon_instance_from_pool(weapon.path, weapon.name)	


func get_weapon_instance_explicit(weapon_path : String, weapon_name : String):
	return weapon_pool.get_weapon_instance_from_pool(weapon_path, weapon_name)


func clean_weapon_instance(weapon_instance : Node):
	weapon_pool.return_weapon_instance_to_queue(weapon_instance)

#SHORT SWORD

func spawn_short_sword():	
	var new_short_sword = get_weapon_instance("Short Sword")
	add_child(new_short_sword)
	new_short_sword.initialise_short_sword(class_weapons["Short Sword"], player)
		
		
#MAGIC MISSILE

func spawn_missile():
	#var target_direction = enemies.get_nearest_enemy_direction(player.global_position)	
	for direction in get_missile_directions():		
		var new_missile = get_weapon_instance("Magic Missile")	
		add_child(new_missile)	
		new_missile.initialise_projectile(direction, weapons["Magic Missile"],	player.global_position, null, false)	


func get_missile_directions() -> Array:	
	var directions = []
	#var base_direction = player.last_direction if player.player_velocity == Vector2.ZERO else player.player_velocity * 1000
	var base_direction = Vector2(-1000, 0) if player.player_facing == "left" else Vector2(1000, 0)
	var base_angle_deviation = 5
	var angle_multiplier = -1

	for i in weapons["Magic Missile"].projectile_count - 1:
		if not i == 0 and i % 2 == 0:
			base_angle_deviation += 5

		angle_multiplier = angle_multiplier * -1
		var angle_deviation = base_angle_deviation * angle_multiplier
		directions.append(base_direction.rotated(deg2rad(angle_deviation)))		

	directions.append(base_direction)
	return directions		
	
	
#SAWBLADE

func spawn_sawblade(disposable_timer : Timer):
	var random_enemy = enemies.get_random_on_screen_enemy(600, 600)
	var travel_direction = Vector2(-1000, 0) if random_enemy == null else (player.global_position.direction_to(random_enemy.global_position) * 1000)
	var new_sawblade = get_weapon_instance("Saw Blade")	
	add_child(new_sawblade)	
	new_sawblade.initialise_sawblade(weapons["Saw Blade"], player, travel_direction)
	
	if not disposable_timer == null:
		disposable_timer.queue_free()
	
			
#HYDRA	

func spawn_hydra(disposable_timer : Timer, spawn_location : Vector2, is_child : bool, hydra_z_index : int):
	var new_hydra = get_weapon_instance("Hydra")	
	add_child(new_hydra)	
	var hydra_spawn_point = spawn_location if not spawn_location == Vector2.ZERO else player.global_position
	new_hydra.initialise_hydra(weapons["Hydra"], hydra_spawn_point, false if is_child else true, hydra_z_index)

	if not disposable_timer == null:
		disposable_timer.queue_free()


func trigger_hydra_attack(hydra : Node):
	var shot_direction = enemies.get_nearest_enemy_direction(hydra.global_position)
	hydra.start_attack_animation(shot_direction)


func spawn_firebolt(shot_direction : Vector2, spawn_point : Vector2):
	var new_firebolt = get_weapon_instance_explicit("res://scenes/weapons/Firebolt.tscn", "Firebolt")
	add_child(new_firebolt)	
	new_firebolt.initialise_projectile(shot_direction, weapons["Hydra"], spawn_point, 3.0, false)	
	

#METEOR

func spawn_meteor(disposable_timer : Timer):
	var new_meteor = get_weapon_instance("Meteor")
	add_child(new_meteor)
	var random_enemy = enemies.get_random_on_screen_enemy(300, 140)
	new_meteor.initialise_meteor(weapons["Meteor"], player.global_position, Vector2.ZERO if random_enemy == null else random_enemy.global_position)
	
	if not disposable_timer == null:
		disposable_timer.queue_free()


#DISCO BALL	

func spawn_disco_ball():
	var new_disco_ball = get_weapon_instance("Disco Ball")
	player.add_child(new_disco_ball)
	new_disco_ball.initialise_disco_ball(weapons["Disco Ball"], player.global_position)
	

func update_disco_ball_stats():
	var disco_ball = player.get_node("DiscoBall")
	disco_ball.update_stats(weapons["Disco Ball"])


#CHAIN LIGHTNING

func spawn_chain_lightning(spawn_point : Vector2, previously_zapped_enemy, zap_count : int):
	var new_chain_lightning = get_weapon_instance("Chain Lightning")
	var nearby_enemies = [enemies.get_nearest_enemy(player.global_position)] if zap_count == 0 else enemies.get_enemies_in_rect(330, 180)
	add_child(new_chain_lightning)
	var lightning_instances = []
	
	if not zap_count == 1 or weapons["Chain Lightning"].summon_count == 1:
		lightning_instances.append(get_weapon_instance_explicit("res://scenes/weapons/Lightning.tscn", "Lightning"))
	else:
		for i in weapons["Chain Lightning"].summon_count:
			lightning_instances.append(get_weapon_instance_explicit("res://scenes/weapons/Lightning.tscn", "Lightning"))
	
	new_chain_lightning.initialise_chain_lightning(weapons["Chain Lightning"], spawn_point, nearby_enemies, previously_zapped_enemy, zap_count, lightning_instances)


#IMPALE

func spawn_impale(disposable_timer : Timer):
	var nearest_enemy = enemies.get_nearest_enemy(player.global_position)
	
	if not nearest_enemy == null:
		var new_impale = get_weapon_instance("Impale")
		add_child(new_impale)
		new_impale.initialise_impale(weapons["Impale"], nearest_enemy.global_position, player.global_position)
	
	if not disposable_timer == null:
		disposable_timer.queue_free()
	
	
#BOOMERANG

func spawn_boomerang(disposable_timer : Timer):	
	var new_boomerang = get_weapon_instance("Boomerang")
	add_child(new_boomerang)
	new_boomerang.initialise_boomerang(weapons["Boomerang"], player.global_position)
	
	if not disposable_timer == null:
		disposable_timer.queue_free()


#BINGLING

func spawn_bingling(disposable_timer : Timer):	
	var new_bingling = get_weapon_instance("Bingling")
	add_child(new_bingling)
	var nearest_enemy = enemies.get_nearest_enemy(player.global_position)
	new_bingling.initialise_bingling(weapons["Bingling"], player.global_position, nearest_enemy)
	
	if not disposable_timer == null:
		disposable_timer.queue_free()


func retarget_bingling(bingling : Node):
	var nearest_enemy = enemies.get_nearest_enemy(bingling.global_position)
	bingling.set_target(nearest_enemy)


#TESLA COIL

func spawn_tesla_coil():
	var tesla_coil_instance = get_weapon_instance("Tesla Coil")
	add_child(tesla_coil_instance)
	tesla_coil_instance.initialise_tesla_coil(weapons["Tesla Coil"], player.global_position)


func trigger_tesla_coil_attack(tesla_instance : Node):
	var lightning_instances = []

	for i in weapons["Tesla Coil"].projectile_count:
		lightning_instances.append(get_weapon_instance_explicit("res://scenes/weapons/Lightning.tscn", "Lightning"))
	
	tesla_instance.zap(lightning_instances)


#FROZEN ORB

func spawn_frozen_orb():
	var random_enemy = enemies.get_random_on_screen_enemy(600, 600)
	var travel_direction = Vector2(1000, 0) if random_enemy == null else (player.global_position.direction_to(random_enemy.global_position) * 1000)
	var frozen_orb_instance = get_weapon_instance("Frozen Orb")
	add_child(frozen_orb_instance)
	frozen_orb_instance.initialise_frozen_orb(weapons["Frozen Orb"], player.global_position, travel_direction)

	
func spawn_icicle(shot_direction : Vector2, spawn_position : Vector2):
	var icicle_instance = get_weapon_instance_explicit("res://scenes/weapons/Icicle.tscn", "Icicle")
	add_child(icicle_instance)	
	icicle_instance.initialise_projectile(shot_direction, get_icicle_weapon_model(), spawn_position, 3.0, false)	


func get_icicle_weapon_model():
	var orb = weapons["Frozen Orb"]
	var icicle_weapon = Weapon.new()
	
	icicle_weapon.damage_type = "ice"
	icicle_weapon.min_damage = max(1.0, orb.min_damage / 1.5)
	icicle_weapon.max_damage = max(1.0, orb.max_damage / 1.5)
	icicle_weapon.crit_rate = orb.crit_rate
	icicle_weapon.crit_damage = orb.crit_damage
	icicle_weapon.projectile_speed = orb.projectile_speed + 150.0
	icicle_weapon.penetration = orb.penetration
	
	return icicle_weapon
	
	
	
