extends Node

var rng = RandomNumberGenerator.new()
var game_height : float = 360.0
var game_width : float = 640.0
var currency : int = 0
var save_file : String = "user://loppu_save.save"


func generate_save_data():
	var save_data : Dictionary = {}
	save_data["currency"] = currency
	
	return save_data
	

func save_game():
	var file = File.new()
	file.open(save_file, File.WRITE)
	file.store_var(generate_save_data())
	file.close()


func load_save():
	var file = File.new()
	
	if file.file_exists(save_file):
		file.open(save_file, File.READ)
		
		var save_data = file.get_var()
		currency = save_data["currency"]
		
		file.close()
	else:
		currency = 0
		
		


	
