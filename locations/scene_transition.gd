extends Area2D
class_name SceneTransition

@export var from_location: String
@export var to_location: String
@export var leads_to: PackedStringArray
@export var spawn_point: Node2D

signal player_entered
signal npc_entered

func _ready():
	set_collision_layer_value(1, false)
	set_collision_layer_value(5, true)
	set_collision_mask_value(4, true)
	body_entered.connect(entered)
	await get_tree().create_timer(.1).timeout
	if World.location_handler != null:
		player_entered.connect(World.location_handler.change_location)
		npc_entered.connect(World.location_handler.change_location)

func entered(body):
	if body is Player:
		player_entered.emit(body, from_location, to_location)
	if body is NPC:
		npc_entered.emit(body, from_location, to_location)
