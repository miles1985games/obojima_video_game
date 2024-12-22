extends Node2D

@onready var fade_animations = $FX_UI/FadeAnimations

var active_location
@onready var locations = $"../Locations"

func _ready():
	World.location_handler = self

func change_location(id):
	fade_animations.play("fade_to_black")
	await fade_animations.animation_finished
	
	active_location.hide()
	
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
	
	active_location.spawn_player()
	active_location.show()
	fade_animations.play("fade_in")
	
func check_for_loaded_locations(id):
	for i in locations.get_children():
		if i.location_id == id:
			return i
