extends Node2D


var current_zone = "Zone_05"
var zone_length = 1000
var player : Node = null


func _ready() -> void:
	$ZONE_01.connect("player_entered_zone", self, "set_current_zone")
	$ZONE_02.connect("player_entered_zone", self, "set_current_zone")
	$ZONE_03.connect("player_entered_zone", self, "set_current_zone")
	$ZONE_04.connect("player_entered_zone", self, "set_current_zone")
	$ZONE_05.connect("player_entered_zone", self, "set_current_zone")
	$ZONE_06.connect("player_entered_zone", self, "set_current_zone")
	$ZONE_07.connect("player_entered_zone", self, "set_current_zone")
	$ZONE_08.connect("player_entered_zone", self, "set_current_zone")
	$ZONE_09.connect("player_entered_zone", self, "set_current_zone")
	
	zone_length = $ZONE_01.get_node('ZoneCollider').shape.extents.x * 2
	

func set_current_zone(zone : String):
	print("Player entered " + zone)
	current_zone = zone
	

func run_treadmill(treadmill_direction : String):
	var furthest_zones = get_furthest_zones(treadmill_direction)
	
	for i in 9:
		var zone_name = 'ZONE_0' + str(i + 1)
		var zone = get_node(zone_name)#get_tree().get_root().get_node(zone_name)
		var is_zone_furthest = furthest_zones.has(zone_name)
		var distance_to_move = 0
		
		if treadmill_direction == 'north' or treadmill_direction == 'south':
			if is_zone_furthest:
				distance_to_move = (-(zone_length) if treadmill_direction == 'north' else zone_length) * 2
			else:
				distance_to_move = zone_length if treadmill_direction == 'north' else -(zone_length)
				
			zone.global_position.y += distance_to_move
			shift_zone_entities(zone_name, distance_to_move, false)
			
		elif treadmill_direction == 'east' or treadmill_direction == 'west': 
			if is_zone_furthest:
				distance_to_move = (zone_length if treadmill_direction == 'east' else -(zone_length)) * 2				
			else:
				distance_to_move = -(zone_length) if treadmill_direction == 'east' else zone_length
			
			zone.global_position.x += distance_to_move
			shift_zone_entities(zone_name, distance_to_move, true)


func shift_zone_entities(zone_name : String, shift_distance : int, shift_horizontally : bool):
	var zone = get_node(zone_name)
	
	if current_zone == zone_name:
		if shift_horizontally:
			player.global_position.x += shift_distance
		else:
			player.global_position.y += shift_distance
					
	var bodies_in_zone = zone.get_overlapping_bodies()
	
	for body in bodies_in_zone:
		if (body.is_in_group('treadmill')):
			if shift_horizontally:
				body.global_position.x += shift_distance
			else:
				body.global_position.y += shift_distance
				
	var areas_in_zone = zone.get_overlapping_areas()
	
	for area in areas_in_zone:
		if (area.is_in_group('treadmill')):
			if shift_horizontally:
				area.global_position.x += shift_distance
			else:
				area.global_position.y += shift_distance


#returns an array of zones in the row/column that is furthest away from the player
#will return zones in the furthest ROW is treadmill_direction is north/south
#will return zones in the furthest COLUMN is treadmill_direction is east_west
func get_furthest_zones(treadmill_direction : String) -> Array:
	if treadmill_direction  == 'north':
		if current_zone == 'ZONE_01' or current_zone == 'ZONE_02' or current_zone == 'ZONE_03':
			return ['ZONE_07', 'ZONE_08', 'ZONE_09']
		elif current_zone == 'ZONE_04' or current_zone == 'ZONE_05' or current_zone == 'ZONE_06':
			return ['ZONE_01', 'ZONE_02', 'ZONE_03']
		else:
			return ['ZONE_04', 'ZONE_05', 'ZONE_06']
	
	if treadmill_direction == 'east':
		if current_zone == 'ZONE_01' or current_zone == 'ZONE_04' or current_zone == 'ZONE_07':
			return ['ZONE_02', 'ZONE_05', 'ZONE_08']
		elif current_zone == 'ZONE_02' or current_zone == 'ZONE_05' or current_zone == 'ZONE_08':
			return ['ZONE_03', 'ZONE_06', 'ZONE_09']
		else:
			return ['ZONE_01', 'ZONE_04', 'ZONE_07']
	
	if treadmill_direction == 'south':
		if current_zone == 'ZONE_01' or current_zone == 'ZONE_02' or current_zone == 'ZONE_03':
			return ['ZONE_04', 'ZONE_05', 'ZONE_06']
		elif current_zone == 'ZONE_04' or current_zone == 'ZONE_05' or current_zone == 'ZONE_06':
			return ['ZONE_07', 'ZONE_08', 'ZONE_09']
		else:
			return ['ZONE_01', 'ZONE_02', 'ZONE_03']
	
	if treadmill_direction == 'west':
		if current_zone == 'ZONE_01' or current_zone == 'ZONE_04' or current_zone == 'ZONE_07':
			return ['ZONE_03', 'ZONE_06', 'ZONE_09']
		elif current_zone == 'ZONE_02' or current_zone == 'ZONE_05' or current_zone == 'ZONE_08':
			return ['ZONE_01', 'ZONE_04', 'ZONE_07']
		else:
			return ['ZONE_02', 'ZONE_05', 'ZONE_08']
			
	return []


func _on_ZoneTrigger_N_area_entered(area: Area2D) -> void:
	if area.get_name() == 'ZoneTriggerDetector':
		print("TRIGGERED NORTH TREADMILL")
		run_treadmill("north")


func _on_ZoneTrigger_E_area_entered(area: Area2D) -> void:
	if area.get_name() == 'ZoneTriggerDetector':
		print("TRIGGERED EAST TREADMILL")
		run_treadmill("east")


func _on_ZoneTrigger_S_area_entered(area: Area2D) -> void:
	if area.get_name() == 'ZoneTriggerDetector':
		print("TRIGGERED SOUTH TREADMILL")
		run_treadmill("south")


func _on_ZoneTrigger_W_area_entered(area: Area2D) -> void:
	if area.get_name() == 'ZoneTriggerDetector':
		print("TRIGGERED WEST TREADMILL")
		run_treadmill("west")
