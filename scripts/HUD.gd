extends CanvasLayer

signal reset_button_pressed()
signal upgrade_selected(upgrade)
signal treasure_selected(equipment)
signal reroll_selected()
signal round_manually_ended()
signal round_finished()

onready var skill_card = preload("res://assets/img/skill_card.png")
onready var skill_card_highlight = preload("res://assets/img/skill_card_highlight.png")

onready var scores = $Scores

onready var health_bar_top = $HealthBarTop
onready var health_bar_bottom = $HealthBarBottom
onready var hearts = $Hearts
onready var tween = $Tween
onready var pause_screen = $Pause
onready var fps = $FPS
#onready var currency = $Currency
onready var total_currency = $TotalCurrency

onready var game_over = $GameOverLabel
onready var results_screen = $Results
onready var upgrade_screen = $Upgrade
onready var treasure_screen = $Treasure
onready var equipment = $Equipment
onready var skill_bar = $SkillBar

var is_paused = false
var is_selecting_upgrade = false
var is_game_over = false
var enemy_counter : int = 0


func _ready() -> void:
	upgrade_screen.connect("upgrade_selected", self, "emit_selected_upgrade")
	upgrade_screen.connect("reroll_selected", self, "emit_reroll")
	
	treasure_screen.connect("treasure_selected", self, "emit_treasure_selected")
	
	pause_screen.connect("resume_selected", self, "handle_resume")
	pause_screen.connect("end_selected", self, "handle_round_end")	
	
	results_screen.connect("player_clicked_finish", self, "handle_finish_clicked")


func _input(event):
	if event.is_action_pressed("pause") and not is_selecting_upgrade:
		toggle_pause()




# === UPGRADES ===

func show_upgrades(upgrades : Array, reroll_cost : int):
	if not is_game_over:
		upgrade_screen.show_upgrades(upgrades, reroll_cost)


func hide_upgrades():
	upgrade_screen.close_upgrades()


func emit_selected_upgrade(upgrade : Upgrade):
	emit_signal("upgrade_selected", upgrade)
	

func emit_reroll():
	emit_signal("reroll_selected")




# === TREASURE ===

func show_treasure(equipment : Array):
	treasure_screen.show_treasure(equipment)
	

func emit_treasure_selected(equipment : Equipment):
	emit_signal("treasure_selected", equipment)
	

func hide_treasure():
	treasure_screen.hide_treasure()


func update_equipment_icons(current_equipment : Dictionary):
	equipment.update_icons(current_equipment)


# === PAUSE ===


func toggle_pause():
	if is_paused:
		get_tree().paused = false
		hide_pause()
		is_paused = false
	else:
		get_tree().paused = true			
		show_pause()
		is_paused = true


func show_pause():
	pause_screen.initialise_pause_screen()
	
	
func hide_pause():
	pause_screen.close_pause_screen()


func upgrade_pause():
	is_selecting_upgrade = true
	get_tree().paused = true
	
	
func upgrade_unpause():
	is_selecting_upgrade = false
	get_tree().paused = false


func handle_resume():
	toggle_pause()
	

func handle_round_end():
	get_tree().paused = false
	emit_signal("round_manually_ended")
	
	


# === TOP BAR ===
		

func update_exp_bar(current_exp : float, max_exp : float):
	skill_bar.update_exp_bar(current_exp, max_exp)
	
	var exp_bar_fill_percentage = (current_exp / max_exp) * 100
	
	if current_exp == 0 or exp_bar_fill_percentage == 0:
		hide_exp_bar()
		return
		
	var exp_bar_max_width = 265 #(269 - 4)  because of start + end bits
	var exp_bar_start = $TopBar/EXPStart
	var exp_bar = $TopBar/EXPBar	
	var exp_bar_width = exp_bar_max_width * (exp_bar_fill_percentage / 100.0)	
	exp_bar.scale.x = exp_bar_width
	var exp_bar_start_right_edge = exp_bar_start.global_position.x + (exp_bar_start.texture.get_width() / 2)
	exp_bar.global_position = Vector2(exp_bar_start_right_edge + (exp_bar_width / 2), exp_bar_start.global_position.y)
	$TopBar/EXPEnd.global_position.x = exp_bar.global_position.x + (exp_bar_width / 2)
	show_exp_bar()
	
	
func show_exp_bar():
	$TopBar/EXPStart.visible = true
	$TopBar/EXPBar.visible = true
	$TopBar/EXPEnd.visible = true


func hide_exp_bar():
	$TopBar/EXPStart.visible = false
	$TopBar/EXPBar.visible = false
	$TopBar/EXPEnd.visible = false




# === MISC ===


func update_hp_bar(new_value : float, max_value : float):
	if new_value <= 0.0:
		health_bar_top.visible = false
		health_bar_bottom.visible = false
		
	health_bar_top.value = new_value
	
	tween.interpolate_property(health_bar_bottom, "value", health_bar_bottom.value, new_value, 0.4, Tween.TRANS_SINE, Tween.EASE_IN_OUT, 0.4)
	tween.start()
	
	health_bar_top.max_value = max_value
	health_bar_bottom.max_value = max_value


func update_hearts(new_value : float, max_hearts : float):
	hearts.render_hearts(int(new_value), int(max_hearts) - int(new_value))


func update_time(time : String):
	scores.update_time(time)
	$GameTimerLabel.text = time


func update_player_level(player_level : int):
	$PlayerLevel.text = "LVL " + str(player_level)
	$PlayerLevelLabel.text = "lvl" + ("0" if player_level < 10 else "") + str(player_level)


func update_enemy_counter(amount : int):
	enemy_counter += amount
	$EnemyCounterLabel.text = "enemies remaining: " + str(enemy_counter)
	$EnemyCounterLabel.visible = true
	

func update_weapon_bar(weapons : Array):	
	skill_bar.update_weapon_icons(weapons)


func start_cooldown_indicator(skill_number : int, cooldown_time : float):
	skill_bar.start_cooldown_indicator(skill_number, cooldown_time)
	

func get_weapon_frame(weapon_level : int):
	return self.get("skill_portrait_" + str(weapon_level + 1))


func update_fps(frames_per_second : float):
	fps.text = "FPS: " + str(int(frames_per_second))


func update_currency(amount : int):
	scores.update_currency(amount)
#	currency.text = "$$$: " + str(amount)


func update_total_currency(amount : int):
	total_currency.text = "Total $$$: " + str(amount)
	

func update_kills(kills : int):
	scores.update_kills(kills)


# === POST-GAME ===


func show_death_message():
	is_game_over = true
	game_over.visible = true


func show_results(results : Dictionary):
#	$GameOverLabel.visible = true
#	$ResetButton.visible =  true
	game_over.visible = false
	results_screen.initialise_results(results)
	results_screen.visible = true


func handle_finish_clicked():
	emit_signal("round_finished")
