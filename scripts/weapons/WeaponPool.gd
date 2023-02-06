extends Node2D

var base_pool_sizes : Dictionary = {
	"Magic Missile" : 50,
	"Saw Blade": 10,
	"Hydra": 20,
	"Firebolt" : 150,
	"Meteor" : 10,
	"Disco Ball" : 1,
	"Chain Lightning" : 30,
	"Lightning" : 100,
	"Impale" : 5,
	"Boomerang" : 10,
	"Bingling" : 20,
	"Tesla Coil" : 3,
	"Frozen Orb" : 3,
	"Icicle" : 150,
	"Short Sword" : 3
}

var weapon_pool : Dictionary = {}
var return_queue : Array = []


func _process(delta: float) -> void:
	clean_return_queue()


func initialise_weapon_pool(weapons : Dictionary):
	for weapon_name in weapons:
		var weapon = weapons[weapon_name]
		load_weapon_instances(weapon.path, weapon.name, false)
	
	load_weapon_instances("res://scenes/weapons/Firebolt.tscn", "Firebolt", false)
	load_weapon_instances("res://scenes/weapons/Lightning.tscn", "Lightning", false)
	load_weapon_instances("res://scenes/weapons/Icicle.tscn", "Icicle", false)


func get_weapon_instance_from_pool(weapon_path : String, weapon_name : String) -> Node:
	var weapon_instance
	
	if not weapon_path in weapon_pool:
		load_weapon_instances(weapon_path, weapon_name, true)
	
	weapon_instance = weapon_pool[weapon_path][0]
	weapon_pool[weapon_path].erase(weapon_instance)
	
	if (len(weapon_pool[weapon_path]) < 1):
		weapon_pool.erase(weapon_path)
	
	return weapon_instance
	

func load_weapon_instances(weapon_path : String, weapon_name : String, load_one : bool):
	var weapon_resource : Resource = load(weapon_path)
	
	for i in 1 if load_one else base_pool_sizes[weapon_name]:
		var new_weapon_instance = weapon_resource.instance()
		new_weapon_instance.connect("clean_up", self.get_parent(), "clean_weapon_instance")
		
		if weapon_name == "Hydra":
			new_weapon_instance.connect("spawn_extra_hydra", self.get_parent(), "spawn_hydra")
			new_weapon_instance.connect("ready_to_fire", self.get_parent(), "trigger_hydra_attack")
			new_weapon_instance.connect("firebolt_ready", self.get_parent(), "spawn_firebolt")
		elif weapon_name == "Chain Lightning":
			new_weapon_instance.connect("lightning_chain_ready", self.get_parent(), "spawn_chain_lightning")
		elif weapon_name == "Bingling":
			new_weapon_instance.connect("needs_target", self.get_parent(), "retarget_bingling")
		elif weapon_name == "Tesla Coil":
			new_weapon_instance.connect("tesla_ready_to_attack", self.get_parent(), "trigger_tesla_coil_attack")
		elif weapon_name == "Frozen Orb":
			new_weapon_instance.connect("fire_icicle", self.get_parent(), "spawn_icicle")
		
		if weapon_path in weapon_pool:
			weapon_pool[weapon_path].append(new_weapon_instance)
		else:
			weapon_pool[weapon_path] = [new_weapon_instance]

	
func return_weapon_instance_to_queue(weapon_instance):
	if return_queue.has(weapon_instance):
		return
	
	return_queue.append(weapon_instance)


#removes instance from tree ONLY once we can be sure collision is not happening for this object (cause that could cause weird behaviour)
func clean_return_queue():
	while len(return_queue) != 0:
		var weapon_instance = return_queue.pop_front()
		
		if weapon_instance == null:
			return
			
		var instance_parent = weapon_instance.get_parent()
		
		if instance_parent == null:
			return
			
		instance_parent.remove_child(weapon_instance)
		
		if weapon_instance.filename in weapon_pool:
			weapon_pool[weapon_instance.filename].append(weapon_instance)
		else:
			weapon_pool[weapon_instance.filename] = [weapon_instance]
