extends Node2D

signal player_clicked_finish()

onready var level = $LevelLabel
onready var time_survived = $TimeSurvivedLabel
onready var enemies_killed = $EnemiesKilledLabel
onready var gold = $GoldLabel
onready var finish_button = $FinishButton


func initialise_results(results : Dictionary):
	level.text = str(results.level)
	time_survived.text = str(results.time_survived)
	enemies_killed.text = str(results.enemies_killed)
	gold.text = str(results.gold)


func _on_FinishButton_pressed() -> void:
	emit_signal("player_clicked_finish")
	#get_tree().change_scene("res://scenes/Menu.tscn")
	#assert(get_tree().change_scene("res://scenes/Menu.tscn") == OK)


#func _on_FinishButton_mouse_entered() -> void:
#	finish_button.grab_focus()
