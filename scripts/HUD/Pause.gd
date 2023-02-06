extends Node2D

signal resume_selected()
signal end_selected()

onready var options_unfocused = preload("res://assets/img/pause/btn_options_unfocused.png")
onready var options_focused = preload("res://assets/img/pause/btn_options_focused.png")
onready var end_run_unfocused = preload("res://assets/img/pause/btn_end_run_unfocused.png")
onready var end_run_focused = preload("res://assets/img/pause/btn_end_run_focused.png")
onready var exit_unfocused = preload("res://assets/img/pause/btn_exit_game_unfocused.png")
onready var exit_focused = preload("res://assets/img/pause/btn_exit_game_focused.png")
onready var resume_unfocused = preload("res://assets/img/pause/btn_resume_unfocused.png")
onready var resume_focused = preload("res://assets/img/pause/btn_resume_focused.png")

onready var options_button = $Panel/OptionsButton
onready var end_run_button = $Panel/EndRunButton
onready var exit_button = $Panel/ExitButton
onready var resume_button = $Panel/ResumeButton
onready var ghost_button = $Panel/GhostButton


func _input(event: InputEvent) -> void:
	if self.visible == true:
		if event.is_action_pressed("ui_up") or event.is_action_pressed("ui_down") or event.is_action_pressed("up") or event.is_action_pressed("down"):
			if not options_button.has_focus() and not end_run_button.has_focus() and not exit_button.has_focus() and not resume_button.has_focus():
				ghost_button.grab_focus()
		

func initialise_pause_screen():
	self.visible = true
	
	unfocus_buttons()
	options_button.release_focus()
	end_run_button.release_focus()
	exit_button.release_focus()
	resume_button.release_focus()	


func close_pause_screen():
	self.visible = false


func unfocus_buttons():
	options_button.set_normal_texture(options_unfocused)
	end_run_button.set_normal_texture(end_run_unfocused)
	exit_button.set_normal_texture(exit_unfocused)
	resume_button.set_normal_texture(resume_unfocused)

	
func _on_ResumeButton_pressed() -> void:
	emit_signal("resume_selected")


func _on_EndRunButton_pressed() -> void:
	emit_signal("end_selected")


func _on_ExitButton_pressed() -> void:
	get_tree().quit()


func _on_OptionsButton_mouse_entered() -> void:
	options_button.grab_focus()


func _on_EndRunButton_mouse_entered() -> void:
	end_run_button.grab_focus()


func _on_ExitButton_mouse_entered() -> void:
	exit_button.grab_focus()


func _on_ResumeButton_mouse_entered() -> void:
	resume_button.grab_focus()


func _on_OptionsButton_focus_entered() -> void:
	unfocus_buttons()
	options_button.set_normal_texture(options_focused)


func _on_EndRunButton_focus_entered() -> void:
	unfocus_buttons()
	end_run_button.set_normal_texture(end_run_focused)


func _on_ExitButton_focus_entered() -> void:
	unfocus_buttons()
	exit_button.set_normal_texture(exit_focused)


func _on_ResumeButton_focus_entered() -> void:
	unfocus_buttons()
	resume_button.set_normal_texture(resume_focused)



