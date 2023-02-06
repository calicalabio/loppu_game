extends Node2D

onready var time = $Time
onready var currency = $Currency
onready var kills = $Kills


func update_time(_time : String):
	time.text = _time
	

func update_currency(_currency : int):
	currency.text = str(_currency)


func update_kills(_kills : int):
	kills.text = str(_kills)
