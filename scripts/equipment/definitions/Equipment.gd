class_name Equipment

var name : String = ""
var type : String = "" #weapon | off_hand | helmet | chest
var icon = null
var potential_stats : Array = []

var min_minimum_damage : int = 0
var max_minimum_damage : int = 0
var minimum_damage : int = 0
var default_minimum_damage : int = 0

var min_maximum_damage : int = 0
var max_maximum_damage : int = 0
var maximum_damage : int = 0
var default_maximum_damage : int = 0

var min_crit_rate : int = 0
var max_crit_rate : int = 0
var crit_rate : int = 0
var default_crit_rate : int = 0

var min_crit_damage : int = 0
var max_crit_damage : int = 0
var crit_damage : int = 0
var default_crit_damage : int = 0

var min_health : int = 0
var max_health : int = 0
var health : int = 0
var default_health : int = 0

var min_damage_reduction : int = 0
var max_damage_reduction : int = 0
var damage_reduction : int = 0
var default_damage_reduction : int = 0

var min_movespeed : int = 0
var max_movespeed : int = 0
var movespeed : int = 0
var default_movespeed : int = 0

var min_pickup_bonus : int = 0
var max_pickup_bonus : int = 0
var pickup_bonus : int = 0
var default_pickup_bonus : int = 0


func roll_stats():
	for stat in potential_stats:
		if stat == "damage":
			minimum_damage = Global.rng.randi_range(min_minimum_damage, max_minimum_damage)
			maximum_damage = Global.rng.randi_range(min_maximum_damage, max_maximum_damage)
		elif stat == "crit_rate":
			crit_rate = Global.rng.randi_range(min_crit_rate, max_crit_rate)
		elif stat == "crit_damage":
			crit_damage = Global.rng.randi_range(min_crit_damage, max_crit_damage)
		elif stat == "health":
			health = Global.rng.randi_range(min_health, max_health)
		elif stat == "damage_reduction":
			damage_reduction = Global.rng.randi_range(min_damage_reduction, max_damage_reduction)
		elif stat == "movespeed":
			movespeed = Global.rng.randi_range(min_movespeed, max_movespeed)
		elif stat == "pickup_bonus":
			pickup_bonus == Global.rng.randi_range(min_pickup_bonus, max_pickup_bonus)


func roll_default_stats():
	for stat in potential_stats:
		if stat == "damage":
			minimum_damage = default_minimum_damage
			maximum_damage = default_maximum_damage
		elif stat == "crit_rate":
			crit_rate = default_crit_rate
		elif stat == "crit_damage":
			crit_damage = default_crit_damage
		elif stat == "health":
			health = default_health
		elif stat == "damage_reduction":
			damage_reduction = default_damage_reduction
		elif stat == "movespeed":
			movespeed = default_movespeed
		elif stat == "pickup_bonus":
			pickup_bonus == default_pickup_bonus
