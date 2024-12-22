extends Node2D

var inventory_node = preload("res://ui/inventory_node.tscn")

signal trigger_alert

func _ready():
	await get_tree().create_timer(1).timeout
	trigger_alert.connect(World.alert_ui.spawn_alert)

func add_to_inventory(type, item, amount):
	for i in amount:
		var new_item = inventory_node.instantiate()
		new_item.type = type
		new_item.item = item
		call_deferred("add_child", new_item)
	
	match type:
		"ingredient":
			if Ingredients.ingredients_roster[item]["discovered"] == false:
				Ingredients.ingredients_roster[item]["discovered"] = true
				trigger_alert.emit((Ingredients.ingredients_roster[item]["name"] + " discovered!"), Ingredients.ingredients_roster[item]["icon"])

func remove_from_inventory(_type, item, amount):
	for i in amount:
		for c in get_children():
			if c.item == item:
				c.queue_free()