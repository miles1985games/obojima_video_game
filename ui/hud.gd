extends CanvasLayer

@onready var day_label = %DayLabel
@onready var time_label = %TimeLabel
@onready var money_label = %MoneyLabel

func _ready():
	await get_tree().create_timer(.1).timeout
	World.time_handler.time_tick.connect(time_tick)

func time_tick(day, hour, minute):
	if is_instance_valid(World.active_player):
		var money = World.active_player.current_money
		money_label.text = "$" + str(money)
	
	day_label.text = "Day " + str(day + 1)
	
	if hour < 10:
		time_label.text = "0" + str(hour)
	else:
		time_label.text = str(hour)
	
	if minute < 10:
		time_label.text = time_label.text + ":0" + str(minute)
	else:
		time_label.text = time_label.text + ":" + str(minute)
