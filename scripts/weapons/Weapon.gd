class_name Weapon

# == META PROPERTIES

var name : String = ""
var code_name : String = ""
var path : String = ""
var timer_name : String = ""
var description : String = ""
var icon = null
var is_class_weapon : bool = false

var upgrades : Dictionary = {}
#var possible_stat_upgrades : Dictionary = {}
#var stat_caps : Dictionary = {} #the max/min stat value (not the bonus value)
#var max_stat_values : Dictionary = {}

var is_equipped : bool = false 
var pickup_order : int = 0
var weapon_level : int = 0
var frame = null
var next_frame = null

# == PHYSICAL PROPERTIES ==

var damage_type : String = "physical"
#physical is the default damage type with no special properties
#fire damage sets enemies aflame 
#ice damage slows enemies
# lightning damage mini-stuns enemies
#combining two types of ELEMENTAL damage on an enemy will trigger an explosion with extra effects

var base_min_damage : float = 0.0
var base_max_damage : float = 0.0
var base_crit_rate: float = 0.0
var base_crit_damage: float = 0.0
var base_cooldown : float = 0.0
var base_projectile_speed : float = 0.0
var base_projectile_count : int = 0
var base_penetration : int = 0
var base_duration : float = 0.0
var base_fire_rate : float = 0.0
var base_summon_count : int = 0
var base_aoe : float = 0.0

var min_damage : float = 0.0
var max_damage : float = 0.0
var crit_rate: float = 0.0
var crit_damage: float = 0.0
var cooldown : float = 0.0
var projectile_speed : float = 0.0
var projectile_count : int = 0
var penetration : int = 0
var duration : float = 0.0
var fire_rate : float = 0.0
var summon_count : int = 0
var aoe : float = 0.0

var damage_bonus : float = 0.0
var crit_rate_bonus: float = 0.0
var crit_damage_bonus: float = 0.0
var cooldown_bonus : float = 0.0
var projectile_speed_bonus : float = 0.0
var size_bonus : float = 0.0
var projectile_count_bonus : int = 0
var penetration_bonus : int = 0
var duration_bonus : float = 0.0
var fire_rate_bonus : float = 0.0
var summon_count_bonus : int = 0
var aoe_bonus : float = 0.0

var knockback_strength : float = 1.0
var can_stun : bool = false
var base_stun_duration : float = 0.0
var stun_duration : float = 0.0
var stun_duration_bonus : float = 0.0

#dead stats
var base_damage : float = 0.0
var damage_level : int = 1
var damage_levels : Dictionary = {}
var damage : float = 0.0


func initialise_stats():
	damage = base_damage
	min_damage = base_min_damage
	max_damage = base_max_damage
	crit_rate = base_crit_rate
	crit_damage = base_crit_damage
	cooldown = base_cooldown
	projectile_speed = base_projectile_speed
	projectile_count = base_projectile_count
	penetration = base_penetration
	duration = base_duration
	fire_rate = base_fire_rate
	summon_count = base_summon_count
	aoe = base_aoe
	stun_duration = base_stun_duration


func get_base_stat_value(stat : String):
	return get("base_" + stat)


func get_stat_value(stat : String):
#	if stat == "Damage":
#		return str(min_damage) + "-" + str(max_damage)
		
	return get(stat)
