extends Position2D

onready var crit_label = $CritLabel
onready var label = $Label
onready var tween = $Tween

var is_idle : bool = true
var number = 0.0
var velocity = Vector2.ZERO
#var rng : RandomNumberGenerator = null
var base_expiry_time : float = 0.8
var time_to_expire : float = 0.8
var is_critical : bool = false

#func _ready():
#	rng.randomize()
#	set_text()
#	set_text_properties()
#	set_velocity()	
#	set_tween()


func initialise_floating_number(_number : float, coordinates : Vector2, is_crit : bool):#, random : RandomNumberGenerator):
#	if rng == null:
#		rng = random
		
	number = _number
	is_critical = is_crit	
	set_visual_properties(coordinates)
	time_to_expire = base_expiry_time
	is_idle = false


func set_visual_properties(coordinates : Vector2):	
	set_text()
	set_velocity()	
	self.global_position = coordinates
	self.global_position.y -= 5	
	self.visible = true


func set_text():
	if is_critical:
		label.visible = false
		crit_label.set_text(str(int(number)))
		crit_label.visible = true
	else:
		crit_label.visible = false
		label.set_text(str(int(number)))
		label.visible = true
	

func set_text_properties():
	var custom_font = label.get("custom_fonts/font")
	label.set("custom_colors/font_color", get_number_color())
	custom_font.outline_color = Color.red if is_critical else Color.white
	
	

func set_velocity():
	var side_movement = Global.rng.randi() % 81 - 40
	velocity = Vector2(side_movement, 25)	


func set_tween():
	tween.interpolate_property(self, 'modulate:a', modulate.a, 0.0, 0.8, Tween.TRANS_LINEAR) #fade out	
	#tween.interpolate_property(self, 'scale', scale, Vector2(1.0, 1.0), 0.2, Tween.TRANS_LINEAR) #grow
	#tween.interpolate_property(self, 'scale', Vector2(1.0, 1.0), Vector2(0.1, 0.1), 0.7, Tween.TRANS_LINEAR, 0.3) #shrink after 0.3 sec delay
	
	#if is_critical:
		#tween.interpolate_property(self, 'scale', scale, Vector2(1.6, 1.6), 0.5, Tween.TRANS_LINEAR) #grow
	
	tween.start()


func get_number_color():
	if not is_critical:
		return Color.black
	else:
		return Color.white


func _process(delta):
	if not is_idle:
		time_to_expire -= delta
		
		if time_to_expire <= 0:
			self.visible = false
			is_idle = true
		
		global_position -= velocity * delta	
