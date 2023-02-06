class_name Wave

var wave : int = 0
var start_time : float = 0.0
var end_time : float = 0.0

#maximum amount of enemies that can exist via trickling
var trickle_max : int = 0

#enemies that trickle in
#key = enemy path, value = spawn weighting
var enemy_weightings : Dictionary = {} 

#array of pattern dictionaries
#key = pattern type, value = spawn time
var enemy_patterns : Array = []

#array of boss dictionaries
# key = boss path, value = spawn time
var bosses : Array = []


func _init(_wave : int, _start_time : float, _end_time : float, _trickle_max : int, _enemy_weightings : Dictionary, _enemy_patterns : Array, _bosses : Array):
	wave = _wave
	start_time = _start_time
	end_time = _end_time
	trickle_max = _trickle_max
	enemy_weightings = _enemy_weightings
	enemy_patterns = _enemy_patterns
	bosses = _bosses	
