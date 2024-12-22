extends CanvasLayer

@onready var grid = %Grid

var inventory_icon = preload("res://ui/inventory_icon.tscn")

func _ready():
	World.potion_ui = self

func open():
	World.active_player.state_machine.state = "ui"
	spawn_ingredients()
	show()

func spawn_ingredients():
	for i in grid.get_children():
		i.free()
	var inventory = World.active_player.inventory.get_children()
	for i in inventory:
		var existing = null
		for e in grid.get_children():
			if e.item == i.item:
				existing = e
		
		if existing != null:
			existing.stack += 1
			existing.populate()
		elif i.type == "ingredient":
			var new_icon = inventory_icon.instantiate()
			new_icon.type = i.type
			new_icon.item = i.item
			grid.add_child(new_icon)
			new_icon.populate()
			new_icon.pressed.connect(ingredient_pressed.bind(new_icon))

func ingredient_pressed(ingredient):
	print(ingredient)


func close_button_pressed():
	World.active_player.state_machine.state = "default"
	hide()
