extends Node2D

@onready var fade_animations = $FX_UI/FadeAnimations

var active_location
@onready var locations = $"../Locations"

func _ready():
	World.location_handler = self

func change_location(body, from_location, to_location):
	if body is Player:
		World.tween_handler.fade_out(active_location, .2)

	var loaded_location = check_for_loaded_locations(to_location)
	
	if loaded_location != null:
		pass
	else:
		var new_location
		for i in World.locations_roster.keys():
			if i == to_location:
				new_location = World.locations_roster[i].instantiate()
				locations.add_child(new_location)
				print("New Location Spawned: " + str(i))
				loaded_location = new_location
					
	body.call_deferred("reparent", loaded_location)
	
	if body is Player:
		active_location = loaded_location
	elif body is NPC:
		body.location_changed(loaded_location)
		
	var spawn_point
	for i in loaded_location.get_children():
		if i is SceneTransition and i.to_location == from_location:
			spawn_point = i.spawn_point.global_position
	body.global_position = spawn_point
	
	if body is Player:
		World.tween_handler.fade_in(loaded_location, .2)
	
func check_for_loaded_locations(id):
	for i in locations.get_children():
		if i.location_id == id:
			return i
