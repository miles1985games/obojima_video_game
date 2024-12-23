extends CanvasLayer

@onready var grid = %Grid
@onready var chosen_ingredient_1 = %ChosenIngredient1
@onready var chosen_ingredient_2 = %ChosenIngredient2
@onready var chosen_ingredient_3 = %ChosenIngredient3
@onready var potion_name_label = %PotionNameLabel
@onready var result_icon = %ResultIcon

var inventory_icon = preload("res://ui/inventory_icon.tscn")
var default_ingredient_icon = preload("res://assets/ui/ingredients_icon.png")

@onready var chosen_panels: Array = [chosen_ingredient_1, chosen_ingredient_2, chosen_ingredient_3]
var chosen_ingredients = []

func _ready():
	World.potion_ui = self
	
	for panel in chosen_panels:
		panel.get_child(1).pressed.connect(remove_button_pressed.bind(panel))

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
			new_icon.pressed.connect(ingredient_pressed.bind(new_icon.item))

func ingredient_pressed(ingredient):
	for i in chosen_panels:
		if i.has_meta("ingredient"):
			pass
		else:
			var current_amount = 0
			var corresponding_icon
			for c in chosen_ingredients:
				if c == ingredient:
					current_amount += 1

			for icon in grid.get_children():
				if icon.item == ingredient:
					corresponding_icon = icon
			
			if corresponding_icon.stack >= current_amount + 1:
				i.set_meta("ingredient", ingredient)
				chosen_ingredients.append(ingredient)
				break
	
	update_chosen_ingredients()

func remove_button_pressed(panel):
	if panel.has_meta("ingredient"):
		for c in chosen_ingredients:
			if c == panel.get_meta("ingredient"):
				chosen_ingredients.erase(c)
				break
		panel.remove_meta("ingredient")
	update_chosen_ingredients()

func update_chosen_ingredients():
	for i in chosen_panels:
		if i.has_meta("ingredient"):
			var ingredient = i.get_meta("ingredient")
			i.get_child(0).texture = Ingredients.ingredients_roster[ingredient]["icon"]
		else:
			i.get_child(0).texture = default_ingredient_icon
	calculate_recipe()

func show_remove_button(panel):
	panel.get_child(1).show()
	
func hide_remove_button(panel):
	panel.get_child(1).hide()

func close_button_pressed():
	World.active_player.state_machine.state = "default"
	hide()

func calculate_recipe():
	var total_combat: int = 0
	var total_utility: int = 0
	var total_whimsy: int = 0
	
	for i in chosen_ingredients:
		total_combat += Ingredients.ingredients_roster[i]["combat"]
		total_utility += Ingredients.ingredients_roster[i]["utility"]
		total_whimsy += Ingredients.ingredients_roster[i]["whimsy"]
	
	var type = "combat"
	var highest_number = total_combat
	if total_utility > total_combat:
		type = "utility"
		highest_number = total_utility
	if total_whimsy > total_utility and total_whimsy > total_combat:
		type = "whimsy"
		highest_number = total_whimsy
	
	if total_combat + total_utility + total_whimsy == 0:
		potion_name_label.text = "No Potion"
	else:
		potion_name_label.text = "Unknown " + type + " potion"
		if Potions.potions_roster.keys().has(type):
			if Potions.potions_roster[type].keys().has(str(highest_number)):
				result_icon.texture = Potions.potions_roster[type][str(highest_number)]["icon"]
				print(Potions.potions_roster[type][str(highest_number)]["name"])
				if Potions.potions_roster[type][str(highest_number)]["discovered"] == false:
					result_icon.modulate = Color.BLACK
