extends CharacterBody2D
class_name NPC

@export var npc_id: String
@export var sprite: AnimatedSprite2D
@export var state_machine: Node2D
@export var nav_agent: NavigationAgent2D

var current_movespeed: float = 2000.0

var current_location: Node2D

func _ready():
	await get_tree().create_timer(.1).timeout
	if World.active_player != null:
		World.active_player.in_ui.connect(pause_movement)
		World.active_player.out_ui.connect(unpause_movement)

func pause_movement():
	state_machine.process_mode = Node.PROCESS_MODE_DISABLED

func unpause_movement():
	state_machine.process_mode = Node.PROCESS_MODE_INHERIT
