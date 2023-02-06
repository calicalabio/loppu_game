extends Node2D

signal resume_selected()
signal end_selected()

onready var resume_default = preload("res://assets/img/btn_resume_inactive.png")
onready var resume_focused = preload("res://assets/img/btn_resume_active.png")
onready var resume_pressed = preload("res://assets/img/btn_resume_clicked.png")

onready var end_default = preload("res://assets/img/btn_end_inactive.png")
onready var end_focused = preload("res://assets/img/btn_end_active.png")
onready var end_pressed = preload("res://assets/img/btn_end_clicked.png")

onready var resume_button = $Resume
onready var end_button = $End


func reset_pause_screen():
	resume_button.grab_focus()


func _on_Resume_pressed() -> void:
	emit_signal("resume_selected")


func _on_End_pressed() -> void:
	emit_signal("end_selected")




# === STUPID BUTTON LOGIC ===
func _on_Resume_mouse_entered() -> void:
	resume_button.grab_focus()
	resume_button.set_normal_texture(resume_focused)


func _on_Resume_focus_entered() -> void:
	resume_button.set_normal_texture(resume_focused)


func _on_Resume_focus_exited() -> void:
	resume_button.set_normal_texture(resume_default)


func _on_Resume_button_down() -> void:
	resume_button.set_normal_texture(resume_pressed)


func _on_Resume_button_up() -> void:
	resume_button.set_normal_texture(resume_focused)


func _on_End_mouse_entered() -> void:
	end_button.grab_focus()
	end_button.set_normal_texture(end_focused)


func _on_End_focus_entered() -> void:
	end_button.set_normal_texture(end_focused)


func _on_End_focus_exited() -> void:
	end_button.set_normal_texture(end_default)


func _on_End_button_down() -> void:
	end_button.set_normal_texture(end_pressed)


func _on_End_button_up() -> void:
	end_button.set_normal_texture(end_focused)








