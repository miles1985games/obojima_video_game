extends Node2D

var inventory_node = preload("res://ui/inventory_node.tscn")

signal ingredient_discovered
signal potion_discovered
signal got_key_item

func _ready():
	await get_tree().create_timer(1).timeout
	ingredient_discovered.connect(World.alert_ui.spawn_alert)
	potion_discovered.connect(World.alert_ui.spawn_alert)
	got_key_item.connect(World.alert_ui.spawn_alert)

func add_to_inventory(type, subtype, item, amount):
	match type:
		"key_item":
			add_key_item(item)
			return
		"ingredient":
			if Ingredients.ingredients_roster[item]["discovered"] == false:
				Ingredients.ingredients_roster[item]["discovered"] = true
				ingredient_discovered.emit((Ingredients.ingredients_roster[item]["name"] + " discovered!"), Ingredients.ingredients_roster[item]["icon"])
		"potion":
			if Potions.potions_roster[subtype][item]["discovered"] == false:
				Potions.potions_roster[subtype][item]["discovered"] = true
				potion_discovered.emit((Potions.potions_roster[subtype][item]["name"] + " discovered!"), Potions.potions_roster[subtype][item]["icon"])

	for i in amount:
		var new_item = inventory_node.instantiate()
		new_item.type = type
		if subtype != null:
			new_item.subtype = subtype
		new_item.item = item
		call_deferred("add_child", new_item)

func add_key_item(item):
	var key_items = World.active_player.key_items
	
	var new_item = KeyItem.new()
	new_item.item = item
	key_items.add_child(new_item)
	got_key_item.emit((item + " received!"), Items.key_items_roster[item]["sprite"])

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
