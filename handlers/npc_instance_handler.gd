extends Node2D
class_name NPCInstanceHandler

@export var npc_id: String
var npc_handler: Node2D
var npc_data: Dictionary
var active_npc: Node2D

func _ready():
	await get_tree().create_timer(.1).timeout
	npc_handler = get_parent()
	World.time_handler.time_tick.connect(check_npc_schedule)
	
	var npcs = Npc.npc_roster
	for i in npcs.keys():
		if i == npc_id:
			npc_data = npcs[i]

func check_npc_schedule(day, hour, minute):
	if active_npc != null:
		pass
	elif npc_data["schedule"].keys().has(hour):
		var targeted_location
		for location in World.location_handler.locations.get_children():
			if location.location_id == npc_data["schedule"][hour]:
				spawn_npc(location)

func spawn_npc(location):
	var new_npc = npc_data["scene"].instantiate()
	new_npc.global_position = location.npc_spawn_points.pick_random().global_position
	location.add_child(new_npc)
	active_npc = new_npc
	new_npc.current_location = location
	new_npc.state_machine.state = "entering_location"
