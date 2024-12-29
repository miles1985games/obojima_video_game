extends Node2D
class_name Location

@export var location_id: String
@export var npc_spawn_point_paths: Array
@onready var npc_spawn_points: Array = load_spawn_points(npc_spawn_point_paths)
@export var npc_enter_point: Node2D

func load_spawn_points(paths):
	var nodes: Array = []
	for path in paths:
		var node = get_node(path)
		if node != null:
			nodes.append(node)
	return nodes
