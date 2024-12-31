extends Interactable
class_name DigSpot

var item

var drop = preload("res://drops/drop.tscn")

signal dug_up

func dig():
	var new_drop = drop.instantiate()
	
	var location: Location = get_parent()
	new_drop.type = "ingredient"
	new_drop.item = item
	
	location.add_child(new_drop)
	new_drop.global_position = global_position
	dug_up.emit(self)
	
	queue_free()
