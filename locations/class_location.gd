extends Node2D
class_name Location

@export var spawn_point: Node2D
@export var location_id: String

func spawn_player():
	if World.active_player != null:
		World.active_player.global_position = spawn_point.global_position
