extends Node2D

@onready var npc_roster = NpcInfo.npc_roster

var max_travelers_per_day: int = 1
var travelers: Array = []
var minutes_since_last_traveler: int = 0
var minutes_between_travelers: int = 10

# Called when the node enters the scene tree for the first time.
func _ready():
	World.npc_handler = self
	await get_tree().create_timer(.1).timeout
	World.time_handler.time_tick.connect(time_tick)

func time_tick(_day, hour, _minute):
	minutes_since_last_traveler += 1
	if travelers.size() < max_travelers_per_day:
		if minutes_since_last_traveler >= minutes_between_travelers:
			var new_traveler = spawn_traveler(hour)
			if new_traveler != null:
				travelers.append(new_traveler)
			minutes_since_last_traveler = 0

func spawn_traveler(hour):
	var traveler_key = npc_roster.keys().pick_random()
	
	while npc_roster[traveler_key]["type"] != "traveler":
		traveler_key = npc_roster.keys().pick_random()
	var new_traveler = npc_roster[traveler_key]["scene"].instantiate()
	var schedule = new_traveler.schedule
	var locations = World.location_handler.locations
	var location_id: String
	var location: Location
	if schedule.keys().has(hour):
		location_id = schedule[hour]
	else:
		var earliest = schedule.keys().pick_random()
		for s in schedule.keys():
			if int(s) < int(earliest):
				earliest = s
		location_id = schedule[earliest]
	
	for l in locations:
		if l.location_id == location_id:
			location = l
	for node in location.get_children():
		if node is NPCEnterPoint:
			new_traveler.global_position = node.global_position
	
	location.add_child(new_traveler)
	
	return new_traveler

func despawn_npc(npc):
	if travelers.has(npc):
		travelers.erase(npc)
	npc.queue_free()
