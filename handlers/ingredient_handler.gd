extends Node2D

var active_ingredients: Dictionary

var spawn_schedule: Dictionary = {"hour": [8], "minute": [0, 1, 2]}

var max_ingredients: int = 10

var drop = preload("res://drops/drop.tscn")
var dig_spot = preload("res://interactables/dig_spot.tscn")

# Called when the node enters the scene tree for the first time.
func _ready():
	World.ingredient_handler = self
	
	await get_tree().create_timer(.1).timeout
	World.time_handler.time_tick.connect(check_ingredient_spawns)
	for location in World.location_handler.locations.get_children():
		active_ingredients[location] = []

func check_ingredient_spawns(day, hour, minute):
	var time: Dictionary = {"day": day, "hour": hour, "minute": minute}
	for location in active_ingredients.keys():
		if active_ingredients[location].size() > max_ingredients:
			pass
		else:
			if spawn_schedule["hour"].has(hour):
				if spawn_schedule["minute"].has(minute):
					for amount in max_ingredients - active_ingredients[location].size():
						spawn_random_ingredient(location)

func spawn_random_ingredient(location: Location):
	if !location.spawnable_ingredients.is_empty():
		var new_instance
		
		if location.ground_tilemap != null:
			var tilemap = location.ground_tilemap
			var random_cell = tilemap.get_used_cells().pick_random()
			var diggable = get_diggable_cell_data(tilemap, random_cell)
			
			var random_item = location.spawnable_ingredients.pick_random()
			
			if diggable:
				new_instance = dig_spot.instantiate()
				new_instance.item = random_item
				new_instance.dug_up.connect(remove_ingredient)
			else:
				new_instance = drop.instantiate()
				new_instance.type = "ingredient"
				new_instance.item = random_item
				new_instance.picked_up.connect(remove_ingredient)
			
			var random_pos = tilemap.map_to_local(random_cell)
			if random_pos != null:
				new_instance.global_position = random_pos
		
		if new_instance != null:
			location.add_child(new_instance)
			active_ingredients[location].append(new_instance)
			

func get_diggable_cell_data(tilemap: TileMapLayer, cell):
	var data: TileData = tilemap.get_cell_tile_data(cell)
	if data and tilemap.tile_set.get_custom_data_layer_by_name("diggable") != -1:
		return data.get_custom_data("diggable")
	else:
		return false

func remove_ingredient(drop):
	for location in active_ingredients.keys():
		if active_ingredients[location].has(drop):
			active_ingredients[location].erase(drop)
