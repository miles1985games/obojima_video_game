extends CharacterBody2D
class_name NPC

@export var npc_id: String
@export var sprite: AnimatedSprite2D
@export var state_machine: Node2D
@export var nav_agent: NavigationAgent2D

var active_interests: Dictionary

var npc_data: Dictionary

var current_movespeed: float = 2000.0

var current_location: Node2D
var targeted_location: String

var nav_ready: bool = false

func _ready():
	current_location = get_parent()
	await get_tree().create_timer(.1).timeout
	if World.active_player != null:
		World.active_player.in_ui.connect(pause_movement)
		World.active_player.out_ui.connect(unpause_movement)
	World.time_handler.time_tick.connect(check_npc_schedule)
	nav_ready = true

	var npcs = NpcInfo.npc_roster
	for i in npcs.keys():
		if i == npc_id:
			npc_data = npcs[i]

func location_changed(new_location):
	current_location = new_location
	if current_location.location_id == targeted_location:
		targeted_location = ""
	else:
		state_machine.state = "exiting_location"
	
	check_interests()

func check_interests():
	active_interests.clear()
	for interest in npc_data["interests"].keys():
		for child in current_location.get_children():
			if child.is_in_group("interest") and child.is_in_group(interest):
				active_interests[interest] = npc_data["interests"][interest]
	print(active_interests)

func pause_movement():
	state_machine.process_mode = Node.PROCESS_MODE_DISABLED

func unpause_movement():
	state_machine.process_mode = Node.PROCESS_MODE_INHERIT

func check_npc_schedule(day, hour, minute):
	if npc_data != null:
		if npc_data["schedule"].keys().has(hour) and targeted_location.is_empty():
			var new_location = npc_data["schedule"][hour]
			if current_location.location_id != new_location:
				targeted_location = new_location
				state_machine.state = "exiting_location"
			#else:
				#state_machine.state = "idle"
