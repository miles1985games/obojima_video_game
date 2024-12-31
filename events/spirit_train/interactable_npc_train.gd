extends InteractableNPC

var has_shovel: bool = false

var drop = preload("res://drops/drop.tscn")

signal finished

func check_for_shovel():
	var key_items = World.active_player.key_items.get_children()
	
	for key in key_items:
		if key.item == "shovel":
			has_shovel = true
	
	if has_shovel:
		dialogue_checked.emit(3)
	else:
		dialogue_checked.emit(5)

func interact_finished():
	if has_shovel:
		pass
	else:
		var location = get_parent()
		while location is not Location:
			location = location.get_parent()
		
		
		var new_drop = drop.instantiate()
		new_drop.type = "key_item"
		new_drop.item = "shovel"
		new_drop.global_position = global_position
		location.add_child(new_drop)
	
	finished.emit()
