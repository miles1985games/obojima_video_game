extends CanvasLayer

@onready var potion_selection_grid = %PotionSelectionGrid
var potion_icon = preload("res://ui/potion_icon.tscn")
@onready var clear_potion_button = %ClearPotionButton

# Called when the node enters the scene tree for the first time.
func _ready():
	World.shop_slot_ui = self
	visibility_changed.connect(spawn_potions)

func show_ui(slot):
	World.active_player.state_machine.state = "ui"
	if slot.potion.is_empty():
		clear_potion_button.disabled = true
	else:
		clear_potion_button.disabled = false
		if clear_potion_button.is_connected("pressed", clear_potion):
			clear_potion_button.disconnect("pressed", clear_potion)
		if clear_potion_button.is_connected("pressed", World.shop_handler.remove_slot):
			clear_potion_button.disconnect("pressed", World.shop_handler.remove_slot)
		clear_potion_button.pressed.connect(clear_potion.bind(slot))
		clear_potion_button.pressed.connect(World.shop_handler.remove_slot.bind(slot))
	show()
	await get_tree().create_timer(.1).timeout
	for icon in potion_selection_grid.get_children():
		icon.pressed.connect(potion_selected.bind(icon, slot))
		icon.pressed.connect(World.shop_handler.add_slot.bind(slot))

func spawn_potions():
	for child in potion_selection_grid.get_children():
		child.queue_free()
	
	var inventory: Array = World.active_player.inventory.get_children()
	var potions: Array
	for i: InventoryNode in inventory:
		if i.type == "potion":
			potions.append(i)
	
	for i: InventoryNode in potions:
		var new_icon = potion_icon.instantiate()
		new_icon.type = i.subtype
		new_icon.id = i.item
		potion_selection_grid.add_child(new_icon)
		new_icon.populate()

func potion_selected(icon, slot):
	slot.potion_type = icon.type
	slot.potion = icon.id
	slot.populate()
	clear()

func _on_close_button_pressed():
	clear()

func clear_potion(slot):
	slot.potion_type = ""
	slot.potion = ""
	slot.populate()
	clear()

func clear():
	hide()
	World.active_player.state_machine.state = "default"
