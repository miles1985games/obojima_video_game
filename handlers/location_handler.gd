extends Node2D

@onready var fade_animations = $FX_UI/FadeAnimations

var active_location
@onready var locations = $"../Locations"

var loading_location: bool = false

func _ready():
	World.location_handler = self

func change_location(id):
	if loading_location == false:
		loading_location = true
		World.tween_handler.fade_out(active_location, .2)
		
		var loaded_location = check_for_loaded_locations(id)
		
		if loaded_location != null:
			active_location = loaded_location
		else:
			var new_location
			for i in World.locations_roster.keys():
				if i == id:
					new_location = World.locations_roster[i].instantiate()
					locations.add_child(new_location)
					print("New Location Spawned: " + str(i))
					active_location = new_location
					
		World.active_player.call_deferred("reparent", active_location)
		World.active_player.global_position = active_location.spawn_point.global_position
		World.tween_handler.fade_in(active_location, .2)
		loading_location = false
	
func check_for_loaded_locations(id):
	for i in locations.get_children():
		if i.location_id == id:
			return i
