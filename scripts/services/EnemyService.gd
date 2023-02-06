extends Node2D

signal enemy_spawned()
signal enemy_took_damage(damage, enemy_coordinates, is_crit)
signal enemy_died(death_coordinates)
signal boss_died(death_coordinates)

onready var enemy_pool : Node = $EnemyPool
onready var wave_service = WaveService.new()
onready var trickle_toggle_timer = $TrickleToggleTimer
onready var enemy_spawn_timer = $EnemySpawnTimer

onready var pattern_types : Dictionary = {
	"TwoColumns" : $TwoColumns,
	"TwoRows" : $TwoRows,
	"Box" : $Box,
	"Swarm" : $Swarm,
	"Sweep" : $Sweep,
	"WideSweep" : $WideSweep
}

#var rng = RandomNumberGenerator.new()
var current_wave : Wave = null
var player : Node = null
var is_trickling : bool = true
var spawn_x_extent = Global.game_width / 2
var spawn_y_extent = Global.game_height / 2
var spawn_margin = 40.0


func _ready() -> void:
#	rng.randomize()
	enemy_pool.initialise_enemy_pool()
	wave_service.intialise_waves()
	
	enemy_spawn_timer.connect("timeout", self, "try_trickle_enemy")
	enemy_spawn_timer.start()
	
	#trickle_toggle_timer.connect("timeout", self, "toggle_trickle_spawner")
	trickle_toggle_timer.start()


func update_current_wave(time : float):
	if current_wave == null or time >= current_wave.end_time:
		current_wave = wave_service.get_current_wave(time)
		initialise_wave_pattern_timers()
		initialise_boss_timers()


func initialise_wave_pattern_timers():
	for pattern in current_wave.enemy_patterns:
		var pattern_name = pattern.keys()[0]
		var pattern_value = pattern[pattern_name]
		var pattern_node = pattern_types[pattern_name]
		var pattern_enemy = null if pattern_value[1] == null else pattern_value[1]
		var pattern_timer = Timer.new()
		pattern_timer.one_shot = true
		pattern_timer.set_wait_time(pattern_value[0])
		pattern_timer.connect("timeout", self, "spawn_pattern", [pattern_node, pattern_enemy])
		add_child(pattern_timer)
		pattern_timer.start()		


func initialise_boss_timers():
	for boss in current_wave.bosses:
		var boss_path = boss.keys()[0]
		var boss_timer = Timer.new()
		boss_timer.one_shot = true
		boss_timer.set_wait_time(boss[boss_path])
		boss_timer.connect("timeout", self, "spawn_enemy", [boss_path, true])
		add_child(boss_timer)
		boss_timer.start()		


func try_trickle_enemy():
	if is_trickling and not current_wave == null and get_enemy_count() < current_wave.trickle_max:
		spawn_enemy("", false)


func spawn_enemy(path : String, is_boss : bool):
	if is_boss:
		print("spawning boss")
#	var new_enemy = load(get_random_enemy_path()).instance()	
	var new_enemy = enemy_pool.get_enemy_instance_from_pool(path if not path.empty() else get_random_enemy_path())	
#	new_enemy.target = player
	new_enemy.global_position = get_random_spawn_location(player.global_position)
#	new_enemy.is_boss = is_boss		
#	new_enemy.connect("enemy_damaged", self, "handle_enemy_damaged")
#	new_enemy.connect("enemy_died", self, "handle_enemy_death")
	add_child(new_enemy)
	new_enemy.initialise_enemy(player, is_boss)
	emit_signal("enemy_spawned")
	

func spawn_pattern(pattern : Node, enemy_type):
	pattern.global_position = Vector2(player.global_position.x - 320, player.global_position.y - 160)
	
	if pattern.has_method("initialise_swarm"):
		pattern.initialise_swarm(player.global_position)
	
	var spawn_points = pattern.get_enemy_spawn_points(pattern.get_name())

	for spawn_point in spawn_points:
		spawn_enemy_at_position(spawn_point, enemy_type)


func spawn_enemy_at_position(spawn_position : Vector2, enemy_type):
	var new_enemy = enemy_pool.get_enemy_instance_from_pool(get_random_enemy_path() if enemy_type == null else enemy_type)	
	new_enemy.global_position = spawn_position
	add_child(new_enemy)
	new_enemy.initialise_enemy(player, false)
	emit_signal("enemy_spawned")
	
	
func clean_enemy_instance(enemy_instance):
	enemy_pool.return_enemy_instance_to_queue(enemy_instance)	
	

func get_random_enemy_path() -> String:
#	rng.randomize()	
	var enemy_roll = Global.rng.randi_range(1, get_total_enemy_weighting())
	var current_weighting_range = 0
	
	for enemy in current_wave.enemy_weightings:
		current_weighting_range += current_wave.enemy_weightings[enemy]
		
		if enemy_roll <= current_weighting_range:
			return enemy
	
	return ""
		

func get_total_enemy_weighting() -> int:
	var total_weighting : int = 0
	
	for enemy in current_wave.enemy_weightings:
		total_weighting += current_wave.enemy_weightings[enemy]

	return total_weighting


func spawn_enemy_pattern():
	pass


func get_enemy_count() -> int:
	return get_tree().get_nodes_in_group('enemies').size()


func toggle_trickle_spawner():
	is_trickling = !is_trickling


func handle_enemy_damaged(damage_taken : float, enemy_coordinates : Vector2, is_crit : bool):
	emit_signal("enemy_took_damage", damage_taken, enemy_coordinates, is_crit)


func handle_enemy_death(death_coordinates : Vector2):
	emit_signal("enemy_died", death_coordinates)


func handle_boss_death(death_coordinates : Vector2):
	emit_signal("boss_died", death_coordinates)


func get_nearest_enemy_direction(origin_point : Vector2) -> Vector2:
	var nearest_enemy = get_nearest_enemy(origin_point)	
	return origin_point.direction_to(nearest_enemy.global_position if not nearest_enemy == null else Vector2(0, 100))


func get_all_enemies() -> Array:
	return get_tree().get_nodes_in_group('enemies')


func get_all_living_enemies() -> Array:
	var all_enemies = get_all_enemies()
	var living_enemies = []
	
	for enemy in all_enemies:
		if is_instance_valid(enemy) and not enemy.is_dying:
			living_enemies.append(enemy)

	return living_enemies


func get_nearest_enemy(origin_point : Vector2) -> Node:
	var minimum_distance = 999999
	var closest_enemy = null
	
	for i in get_all_living_enemies():
		var origin_to_enemy_distance = origin_point.distance_to(i.global_position)
		
		if (origin_to_enemy_distance < minimum_distance):
			closest_enemy = i
			minimum_distance = origin_to_enemy_distance
			
	return closest_enemy	


func get_random_on_screen_enemy(x_radius : float, y_radius : float) -> Node:
	var enemies_on_screen = get_enemies_in_rect(x_radius, y_radius)
	
	if enemies_on_screen.size() == 0:
		return null
	elif enemies_on_screen.size() == 1:
		return enemies_on_screen[0]
	else:
		var random_enemy_index = Global.rng.randi_range(0, enemies_on_screen.size() - 1)
		return enemies_on_screen[random_enemy_index]


func get_enemies_in_rect(x_radius : float, y_radius : float) -> Array:
	var enemies_on_screen = []
	var player_x = player.global_position.x
	var player_y = player.global_position.y
	
	for enemy in get_all_living_enemies():
		if not enemy.is_dying:
			var enemy_x = enemy.global_position.x
			var enemy_y = enemy.global_position.y
			
			#if enemy is within rect bounds around player
			if enemy_x > (player_x - x_radius) and enemy_x < (player_x + x_radius) and enemy_y > (player_y - y_radius) and enemy_y < (player_y + y_radius):
				enemies_on_screen.append(enemy)
		
	return enemies_on_screen


func get_random_spawn_location(player_location :Vector2) -> Vector2:
	var spawn_direction = Global.rng.randi_range(0, 3)
	
	if spawn_direction == 0:
		return get_random_left_spawn_location(player_location)
	elif spawn_direction == 1:
		return get_random_right_spawn_location(player_location)
	elif spawn_direction == 2:
		return get_random_top_spawn_location(player_location)
	elif spawn_direction == 3:
		return get_random_bottom_spawn_location(player_location)
		
	return Vector2.ZERO


func get_random_left_spawn_location(player_location : Vector2) -> Vector2:
	var x_coord = player_location.x - spawn_x_extent - spawn_margin
	var y_coord = get_random_y_spawn_coord(player_location)
	
	return Vector2(x_coord, y_coord)
	
	
func get_random_right_spawn_location(player_location : Vector2) -> Vector2:
	var x_coord = player_location.x + spawn_x_extent + spawn_margin
	var y_coord = get_random_y_spawn_coord(player_location)
	
	return Vector2(x_coord, y_coord)
	
	
func get_random_top_spawn_location(player_location : Vector2) -> Vector2:
	var x_coord = get_random_x_spawn_coord(player_location)
	var y_coord = player_location.y - spawn_y_extent - spawn_margin
	
	return Vector2(x_coord, y_coord)
	
	
func get_random_bottom_spawn_location(player_location : Vector2) -> Vector2:
	var x_coord = get_random_x_spawn_coord(player_location)
	var y_coord = player_location.y + spawn_y_extent + spawn_margin
	
	return Vector2(x_coord, y_coord)
	
	
func get_random_y_spawn_coord(player_location : Vector2) -> float:
	var min_y_coord = player_location.y - spawn_y_extent - spawn_margin
	var max_y_coord = player_location.y + spawn_y_extent + spawn_margin
	
	return Global.rng.randf_range(min_y_coord, max_y_coord)
	
func get_random_x_spawn_coord(player_location : Vector2) -> float:
	var min_x_coord = player_location.x - spawn_x_extent - spawn_margin
	var max_x_coord = player_location.x + spawn_x_extent + spawn_margin
	
	return Global.rng.randf_range(min_x_coord, max_x_coord)
