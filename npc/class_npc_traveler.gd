extends NPC
class_name Traveler

var targeted_slot: ShopSlot

#first number in dict is potion id, second is favorite rating from 1 to 5
@export var needed_potions: Dictionary = {"combat" = {}, "utility" = {}, "whimsy" = {}}

func _ready():
	super()
	await get_tree().create_timer(.1).timeout
	World.shop_handler.slots_changed.connect(calculate_slots)

func location_changed(new_location):
	super(new_location)
	calculate_slots()

func calculate_slots():
	var slots_in_location: Array = []
	var shop_slots = World.shop_handler.shop_slots
	for slot in shop_slots:
		var parent = slot.get_parent()
		while parent is not Location:
			parent = parent.get_parent()
		if parent == current_location:
			slots_in_location.append(slot)
	
	var targeted_slots: Array
	for type in needed_potions.keys():
		for slot in slots_in_location:
			if slot.potion_type == type:
				for potion in needed_potions[type].keys():
					if potion == slot.potion:
						var slot_array: Array = [slot, needed_potions[type][potion]]
						targeted_slots.append(slot_array)
						targeted_slots.sort_custom(sort_descending)
	
	if !targeted_slots.is_empty():
		targeted_slot = targeted_slots[0][0]
	else:
		targeted_slot = null

func sort_descending(a,b):
	if a[1] < b[1]:
		return true
	return false
