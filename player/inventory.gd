extends Node2D

var inventory_node = preload("res://ui/inventory_node.tscn")

signal ingredient_discovered
signal potion_discovered

func _ready():
	await get_tree().create_timer(1).timeout
	ingredient_discovered.connect(World.alert_ui.spawn_alert)
	potion_discovered.connect(World.alert_ui.spawn_alert)

func add_to_inventory(type, subtype, item, amount):
	for i in amount:
		var new_item = inventory_node.instantiate()
		new_item.type = type
		if subtype != null:
			new_item.subtype = subtype
		new_item.item = item
		call_deferred("add_child", new_item)
	
	match type:
		"ingredient":
			if Ingredients.ingredients_roster[item]["discovered"] == false:
				Ingredients.ingredients_roster[item]["discovered"] = true
				ingredient_discovered.emit((Ingredients.ingredients_roster[item]["name"] + " discovered!"), Ingredients.ingredients_roster[item]["icon"])
		"potion":
			if Potions.potions_roster[subtype][item]["discovered"] == false:
				Potions.potions_roster[subtype][item]["discovered"] = true
				potion_discovered.emit((Potions.potions_roster[subtype][item]["name"] + " discovered!"), Potions.potions_roster[subtype][item]["icon"])

func remove_from_inventory(type, subtype, item):
	print("received: " + str(item))
	for c in get_children():
		if c.type == type:
			if subtype != null and c.subtype != null:
				if c.subtype == subtype:
					if c.item == item:
						c.free()
						print("freed: " + str(c))
						break
			else:
				if c.item == item:
					print("freed: " + str(c))
					c.free()
					break
