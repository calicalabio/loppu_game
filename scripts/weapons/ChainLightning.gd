extends Node2D

signal lightning_chain_ready(next_spawn_point, previous_zapped_enemy, zap_count)
signal clean_up(instance)

var lightning_scene = preload("res://scenes/weapons/Lightning.tscn")

onready var zap_delay_timer : Timer = $ZapDelayTimer
onready var expiry_timer : Timer = $ExpiryTimer

var chain_lightning_data : Weapon = null
var initial_aoe_radius : float = 110.0
var chain_aoe_radius : float = 75.0
var _lightning_instances : Array = []
var _next_spawn_point : Vector2 = Vector2.ZERO
var _previously_zapped_enemy : Node = null
var _zap_count : int = 0
var forked_enemies : Array = []
var has_incremented_zap_count : bool = false


func initialise_chain_lightning(weapon_data : Weapon, spawn_point : Vector2, nearby_enemies : Array, previously_zapped_enemy, zap_count : int, lightning_instances : Array):
	chain_lightning_data = weapon_data
	_lightning_instances = lightning_instances
	zap_delay_timer.wait_time = weapon_data.fire_rate		
	forked_enemies = []
	has_incremented_zap_count = false
	var viable_enemies = get_enemies_in_radius(nearby_enemies, spawn_point, zap_count == 0, previously_zapped_enemy)
	determine_action(viable_enemies, spawn_point, previously_zapped_enemy, zap_count)

		
func get_enemies_in_radius(enemies : Array, center_point : Vector2, initial_shot : bool, vetoed_enemy : Node):
	var viable_enemies = []

	for enemy in enemies:
		if not enemy == null and (vetoed_enemy == null or not enemy == vetoed_enemy):
			if center_point.distance_to(enemy.global_position) <= (initial_aoe_radius if initial_shot else chain_aoe_radius):			
				viable_enemies.append(enemy)

	return viable_enemies
		
		
func determine_action(viable_enemies : Array, spawn_point : Vector2, previously_zapped_enemy, zap_count : int):
	if viable_enemies.size() == 0:
		return

	if zap_count == 1 and chain_lightning_data.summon_count > 1:
		for i in chain_lightning_data.summon_count:
			zap_enemy(spawn_point, viable_enemies, previously_zapped_enemy, zap_count)
	else:
		zap_enemy(spawn_point, viable_enemies, previously_zapped_enemy, zap_count)	
	
		
func zap_enemy(spawn_point : Vector2, nearby_enemies : Array, previously_zapped_enemy, zap_count : int):
	if not previously_zapped_enemy == null and nearby_enemies.has(previously_zapped_enemy):
		nearby_enemies.erase(previously_zapped_enemy)
	
	#if chain lightning can fork, make sure we fork different targets
	if forked_enemies.size() > 0:
		for forked_enemy in forked_enemies:
			if nearby_enemies.has(forked_enemy):
				nearby_enemies.erase(forked_enemy)
	
	if nearby_enemies.size() < 1:
		return
	
	var enemy_index = 0
	
	if nearby_enemies.size() > 1:
		enemy_index = Global.rng.randi_range(0, nearby_enemies.size() - 1)		
	
	var selected_enemy = nearby_enemies[enemy_index]
	forked_enemies.append(selected_enemy)
	var next_spawn_point = selected_enemy.global_position
	create_lightning(spawn_point, next_spawn_point)
	
	selected_enemy.take_damage(chain_lightning_data)
	
	selected_enemy.play_zap_effect()
	selected_enemy = null if selected_enemy.health <= 0 else selected_enemy
	
	if zap_count + 1 < chain_lightning_data.projectile_count:
		_next_spawn_point = next_spawn_point
		_previously_zapped_enemy = selected_enemy
		
		if not has_incremented_zap_count:
			_zap_count  = zap_count + 1
			has_incremented_zap_count = true
		
		queue_next_zap()


func queue_next_zap():
	var zap_timer = Timer.new()
	zap_timer.one_shot = true
	zap_timer.wait_time = chain_lightning_data.fire_rate
	zap_timer.connect("timeout", self, "emit_zap_ready", [_next_spawn_point, _previously_zapped_enemy, _zap_count])
	add_child(zap_timer)
	zap_timer.start()
#	zap_delay_timer.connect("timeout", self, "emit_zap_ready")
#	zap_delay_timer.start()
	expiry_timer.connect("timeout", self, "expire")
	expiry_timer.start()
	
	
func emit_zap_ready(next_spawn_point : Vector2, previously_zapped_enemy : Node, zap_count : int):
	emit_signal("lightning_chain_ready", next_spawn_point, previously_zapped_enemy, zap_count)


func create_lightning(start_point : Vector2, end_point : Vector2):
	var lightning_instance = _lightning_instances[forked_enemies.size() - 1]
	add_child(lightning_instance)
	lightning_instance.initialise_lightning(start_point, end_point)


func clean_weapon_instance(lightning_instance : Node):
	emit_signal("clean_up", lightning_instance)


func expire():
	emit_signal("clean_up", self)
