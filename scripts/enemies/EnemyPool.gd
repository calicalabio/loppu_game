extends Node2D

var base_pool_sizes : Dictionary = {
	"res://scenes/enemies/placeholders/EnemyA.tscn" : 100,
	"res://scenes/enemies/placeholders/EnemyB.tscn" : 100,
	"res://scenes/enemies/placeholders/EnemyC.tscn" : 100,
	"res://scenes/enemies/placeholders/EnemyD.tscn" : 100,
	"res://scenes/enemies/placeholders/EnemyE.tscn" : 100,
	"res://scenes/enemies/placeholders/EnemyF.tscn" : 100,
	"res://scenes/enemies/placeholders/EnemyG.tscn" : 100,
	"res://scenes/enemies/placeholders/EnemyH.tscn" : 100,
	"res://scenes/enemies/placeholders/EnemyI.tscn" : 100,
	"res://scenes/enemies/placeholders/EnemyJ.tscn" : 100,
	"res://scenes/enemies/placeholders/EnemyK.tscn" : 100,
	"res://scenes/enemies/placeholders/EnemyL.tscn" : 100,
	"res://scenes/enemies/placeholders/EnemyM.tscn" : 100,
	"res://scenes/enemies/placeholders/EnemyN.tscn" : 100,
	"res://scenes/enemies/placeholders/EnemyO.tscn" : 100,
	"res://scenes/enemies/placeholders/EnemyP.tscn" : 100,
	"res://scenes/enemies/placeholders/EnemyQ.tscn" : 100,
	"res://scenes/enemies/placeholders/EnemyR.tscn" : 100,
	"res://scenes/enemies/placeholders/EnemyS.tscn" : 100,
	"res://scenes/enemies/placeholders/EnemyT.tscn" : 100,
	"res://scenes/enemies/placeholders/EnemyU.tscn" : 100,
	"res://scenes/enemies/placeholders/EnemyV.tscn" : 100,
	"res://scenes/enemies/placeholders/EnemyW.tscn" : 100,
	"res://scenes/enemies/placeholders/EnemyX.tscn" : 100,
	"res://scenes/enemies/placeholders/EnemyY.tscn" : 100,
	"res://scenes/enemies/placeholders/EnemyZ.tscn" : 100,
	"res://scenes/enemies/placeholders/BossA.tscn" : 10,
	"res://scenes/enemies/placeholders/BossB.tscn" : 10,
	"res://scenes/enemies/placeholders/SwarmerA.tscn" : 25,
	"res://scenes/enemies/Fly.tscn" : 100,
	"res://scenes/enemies/Birb.tscn" : 100,
	"res://scenes/enemies/Blob.tscn" : 100,
	"res://scenes/enemies/Dummy.tscn" : 100,
	"res://scenes/enemies/Yume.tscn" : 100,
	"res://scenes/enemies/MeltingHeart.tscn" : 240,
	"res://scenes/enemies/MrSunday.tscn" : 10
}

var enemy_pool : Dictionary = {}
var return_queue : Array = []


func _process(delta: float) -> void:
	clean_return_queue()


func initialise_enemy_pool():
	for enemy_path in base_pool_sizes:
		load_enemy_instances(enemy_path, false)


func get_enemy_instance_from_pool(enemy_path : String) -> Node:
	var enemy_instance
	
	if not enemy_path in enemy_pool:
		load_enemy_instances(enemy_path, true)
	
	enemy_instance = enemy_pool[enemy_path][0]
	enemy_pool[enemy_path].erase(enemy_instance)
	
	if (len(enemy_pool[enemy_path]) < 1):
		enemy_pool.erase(enemy_path)
	
	return enemy_instance
	

func load_enemy_instances(enemy_path : String, load_one : bool):
	var enemy_resource : Resource = load(enemy_path)
	
	for i in 1 if load_one else base_pool_sizes[enemy_path]:
		var new_enemy_instance = enemy_resource.instance()
		
		new_enemy_instance.connect("enemy_damaged", self.get_parent(), "handle_enemy_damaged")
		new_enemy_instance.connect("enemy_died", self.get_parent(), "handle_enemy_death")
		new_enemy_instance.connect("clean_up", self.get_parent(), "clean_enemy_instance")
		new_enemy_instance.connect("boss_died", self.get_parent(), "handle_boss_death")
		
		if enemy_path in enemy_pool:
			enemy_pool[enemy_path].append(new_enemy_instance)
		else:
			enemy_pool[enemy_path] = [new_enemy_instance]

	
func return_enemy_instance_to_queue(enemy_instance):
	if return_queue.has(enemy_instance):
		return
	
	return_queue.append(enemy_instance)


#removes instance from tree ONLY once we can be sure collision is not happening for this object (cause that could cause weird behaviour)
func clean_return_queue():
	while len(return_queue) != 0:
		var enemy_instance = return_queue.pop_front()
		
		if enemy_instance == null:
			return
			
		var instance_parent = enemy_instance.get_parent()
		
		if instance_parent == null:
			return
			
		instance_parent.remove_child(enemy_instance)
		
		if enemy_instance.filename in enemy_pool:
			enemy_pool[enemy_instance.filename].append(enemy_instance)
		else:
			enemy_pool[enemy_instance.filename] = [enemy_instance]
