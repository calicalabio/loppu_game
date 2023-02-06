extends Node2D

onready var new_game_default = preload("res://assets/img/btn_new_game_inactive.png")
onready var new_game_focused = preload("res://assets/img/btn_new_game_active.png")
onready var new_game_pressed = preload("res://assets/img/btn_new_game_clicked.png")

onready var options_default = preload("res://assets/img/btn_options_inactive.png")
onready var options_focused = preload("res://assets/img/btn_options_active.png")
onready var options_pressed = preload("res://assets/img/btn_options_clicked.png")

onready var quit_default = preload("res://assets/img/btn_quit_inactive.png")
onready var quit_focused = preload("res://assets/img/btn_quit_active.png")
onready var quit_pressed = preload("res://assets/img/btn_quit_clicked.png")

onready var new_game_button = $NewGame
onready var options_button = $Options
onready var quit_button = $Quit
onready var transitioner = $Transitioner


func _ready() -> void:
	Global.load_save()
	new_game_button.grab_focus()
	new_game_button.set_normal_texture(new_game_focused)


func _on_NewGame_pressed() -> void:
	print("change to main scene...")
	get_tree().change_scene("res://scenes/Main.tscn")
	#assert(get_tree().change_scene("res://scenes/Main.tscn") == OK)
	#transitioner.change_scene()


func _on_Options_pressed() -> void:
	pass # Replace with function body.


func _on_Quit_pressed() -> void:
	get_tree().quit()




# === BUTTON FOCUS LOGIC ==

func _on_NewGame_mouse_entered() -> void:
	new_game_button.grab_focus()
	new_game_button.set_normal_texture(new_game_focused)


func _on_Options_mouse_entered() -> void:
	options_button.grab_focus()
	options_button.set_normal_texture(options_focused)


func _on_Quit_mouse_entered() -> void:
	quit_button.grab_focus()
	quit_button.set_normal_texture(quit_focused)


func _on_NewGame_focus_entered() -> void:
	new_game_button.grab_focus()
	new_game_button.set_normal_texture(new_game_focused)


func _on_Options_focus_entered() -> void:
	options_button.grab_focus()
	options_button.set_normal_texture(options_focused)


func _on_Quit_focus_entered() -> void:
	quit_button.grab_focus()
	quit_button.set_normal_texture(quit_focused)


func _on_NewGame_focus_exited() -> void:
	new_game_button.set_normal_texture(new_game_default)


func _on_Options_focus_exited() -> void:
	options_button.set_normal_texture(options_default)


func _on_Quit_focus_exited() -> void:
	quit_button.set_normal_texture(quit_default)


func _on_NewGame_button_down() -> void:
	new_game_button.set_normal_texture(new_game_pressed)


func _on_Options_button_down() -> void:
	options_button.set_normal_texture(options_pressed)


func _on_Quit_button_down() -> void:
	quit_button.set_normal_texture(quit_pressed)


func _on_NewGame_button_up() -> void:
	new_game_button.set_normal_texture(new_game_focused)


func _on_Options_button_up() -> void:
	options_button.set_normal_texture(options_focused)


func _on_Quit_button_up() -> void:
	quit_button.set_normal_texture(quit_focused)
