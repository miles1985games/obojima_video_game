extends Node2D

var this_day: float
var spawned_events: Array = []

# Called when the node enters the scene tree for the first time.
func _ready():
	World.event_handler = self
	await get_tree().create_timer(.1).timeout
	World.time_handler.time_tick.connect(check_event_schedules)

func check_event_schedules(day, hour, minute):
	if day != this_day:
		this_day = day
		spawned_events.clear()
	
	var events = get_children()
	for i in events:
		if i is Event and i.schedule.keys().has(hour) and !spawned_events.has(i):
			if !is_instance_valid(i.active_scene):
				i.spawn_scene(hour)
				spawned_events.append(i)
