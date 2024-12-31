extends Node2D
class_name Event

@export var scene: PackedScene
@export var schedule: Dictionary

var active_scene

func spawn_scene(hour):
	if !is_instance_valid(active_scene):
		if scene != null and hour != null:
			var location_id: String = schedule[hour]
			var location: Node2D
			var locations: Array = World.location_handler.locations.get_children()
			
			for l in locations:
				if l.location_id == location_id:
					location = l
			
			var possible_spawns: Array = []
			for child in location.get_children():
				if child is EventSpawnMarker:
					possible_spawns.append(child.global_position)
			var random_spawn = possible_spawns.pick_random()
			
			var new_scene = scene.instantiate()
			new_scene.global_position = random_spawn
			location.add_child(new_scene)
			new_scene.finished.connect(scene_finished)
			active_scene = new_scene

func scene_finished():
	if is_instance_valid(active_scene):
		active_scene.queue_free()
		active_scene = null
