class_name GameService


func format_time_string(time : float) -> String:
	var seconds = fmod(time, 60)
	var minutes = fmod(time, 60 * 60) / 60
	var formatted_time = "%02d:%02d" % [minutes, seconds]
	
	return formatted_time
