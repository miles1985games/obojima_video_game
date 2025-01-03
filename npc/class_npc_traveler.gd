extends NPC
class_name Traveler

var current_slots: Array = []

#first number in dict is potion id, second is favorite rating from 1 to 5
@export var needed_potions: Dictionary = {"combat" = {}, "utility" = {}, "whimsy" = {}}

func location_changed(new_location):
	super(new_location)
	
	current_slots.clear()
	var shop_slots = World.shop_handler.shop_slots
	for slot in shop_slots:
		var parent = slot.get_parent()
		while parent is not Location:
			parent = parent.get_parent()
		if parent == new_location:
			current_slots.append(slot)
	
	print(current_slots)
	for type in needed_potions.keys():
		for slot in current_slots:
			if slot.potion_type == type:
				for potion in needed_potions[type].keys():
					if potion == slot.potion:
						print("desired potion found")
