extends CanvasLayer

@onready var day_label = %DayLabel
@onready var time_label = %TimeLabel

func time_tick(day, hour, minute):
	day_label.text = "Day " + str(day)
	
	if hour < 10:
		time_label.text = "0" + str(hour)
	else:
		time_label.text = str(hour)
	
	if minute < 10:
		time_label.text = time_label.text + ":0" + str(minute)
	else:
		time_label.text = time_label.text + ":" + str(minute)
