extends CanvasLayer

@onready var grid = %Grid
@onready var chosen_ingredient_1 = %ChosenIngredient1
@onready var chosen_ingredient_2 = %ChosenIngredient2
@onready var chosen_ingredient_3 = %ChosenIngredient3
@onready var potion_name_label = %PotionNameLabel
@onready var result_icon = %ResultIcon
@onready var brew_button: Button = %BrewButton
@onready var recipes_grid: VBoxContainer = %RecipesGrid


var inventory_icon = preload("res://ui/inventory_icon.tscn")
var default_ingredient_icon = preload("res://assets/ui/ingredients_icon.png")
var default_potion_icon = preload("res://assets/ui/potions_icon.png")
var recipe_panel = preload("res://ui/recipe_panel.tscn")

@onready var chosen_panels: Array = [chosen_ingredient_1, chosen_ingredient_2, chosen_ingredient_3]
var chosen_ingredients = []
var calculated_potion_type: String
var calculated_potion_id: String
var calculated_potion_name: String

var known_recipes = {
	"combat" = {},
	"utility" = {},
	"whimsy" = {},
}

signal potion_brewed
signal ingredient_used

func _ready():
	World.potion_ui = self
	
	await get_tree().create_timer(.1).timeout
	potion_brewed.connect(World.active_player.inventory.add_to_inventory)
	ingredient_used.connect(World.active_player.inventory.remove_from_inventory)
	for panel in chosen_panels:
		panel.get_child(1).pressed.connect(remove_button_pressed.bind(panel))

func open():
	World.active_player.state_machine.state = "ui"
	spawn_ingredients()
	spawn_recipes()
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

func save_recipe(potion_type, potion_id, potion_name, ingredients_array):
	var temp_array: Array = []
	for i in ingredients_array:
		temp_array.append(i)
	
	print(known_recipes)
	temp_array.sort_custom(func(a,b): return a < b)
	var recipe_known: bool = false
	
	for t in known_recipes:
		for i in known_recipes[t]:
			for n in known_recipes[t][i]:
				if known_recipes[t][i][n] == temp_array:
					recipe_known = true
					print("found recipe: " + str(known_recipes[t][i][n]) + " ing array: " + str(temp_array))
					break
	if recipe_known:
		print("recipe known")
	else:
		if known_recipes[potion_type].keys().has(potion_id):
			print("recipe unknown")
			var size = known_recipes[potion_type][potion_id].keys().size()
			known_recipes[potion_type][potion_id][size] = temp_array
		else:
			print("potion unknown")
			known_recipes[potion_type][potion_id] = {}
			known_recipes[potion_type][potion_id]["0"] = temp_array
	print(known_recipes)

func spawn_recipes():
	print("spawn recipes")
	for i in recipes_grid.get_children():
		i.queue_free()
	
	for type in known_recipes:
		for id in known_recipes[type]:
			for r in known_recipes[type][id]:
				create_recipe_panel(type, id, known_recipes[type][id][r])
	
	

func create_recipe_panel(potion_type, potion_id, recipe):
	print("create panel")
	var new_recipe = recipe_panel.instantiate()
	
	new_recipe.potion_type = potion_type
	new_recipe.potion_id = potion_id
	new_recipe.ingredients = recipe
	
	recipes_grid.add_child(new_recipe)
	new_recipe.recipe_pressed.connect(recipe_pressed)
	print(new_recipe)

func recipe_pressed(ingredients_array):
	for ingredient in ingredients_array:
		ingredient_pressed(ingredient)

func ingredient_pressed(ingredient):
	for i in chosen_panels:
		if i.has_meta("ingredient"):
			pass
		else:
			if chosen_ingredients.has(ingredient):
				pass
			else:
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
	calculated_potion_type = "none"
	var index = 0
	for i in chosen_panels:
		if i.has_meta("ingredient"):
			var ingredient = i.get_meta("ingredient")
			if i.get_child(0).texture == default_ingredient_icon:
				i.get_child(0).texture = Ingredients.ingredients_roster[ingredient]["icon"]
				World.tween_handler.bounce(i.get_child(0), 1, 1)
			else:
				i.get_child(0).texture = Ingredients.ingredients_roster[ingredient]["icon"]
			i.get_child(0).modulate = Color.WHITE
		else:
			i.get_child(0).texture = default_ingredient_icon
			i.get_child(0).modulate.a = Color.WHITE.a / 2
		index += 1
	if chosen_ingredients.size() >= 3:
		brew_button.disabled = false
		calculate_recipe()
	else:
		clear_details()

func clear_details():
	potion_name_label.text = "No Potion"
	result_icon.texture = default_potion_icon
	brew_button.disabled = true

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
	
	highest_number = str(highest_number)
	if total_combat + total_utility + total_whimsy == 0:
		potion_name_label.text = "No Potion"
	else:
		potion_name_label.text = "Unknown " + type + " potion"
		if Potions.potions_roster.keys().has(type):
			if Potions.potions_roster[type].keys().has(highest_number):
				result_icon.texture = Potions.potions_roster[type][highest_number]["icon"]
				
				calculated_potion_type = type
				calculated_potion_id = highest_number
				calculated_potion_name = Potions.potions_roster[type][highest_number]["name"]
				
				if Potions.potions_roster[type][highest_number]["discovered"] == false:
					result_icon.modulate = Color.BLACK
				else:
					potion_name_label.text = Potions.potions_roster[type][highest_number]["name"]

func brew_button_pressed() -> void:
	if calculated_potion_type != "none":
		for i in chosen_ingredients:
			ingredient_used.emit("ingredient", null, i)
		
		brew_potion(calculated_potion_type, calculated_potion_id, calculated_potion_name)
		World.tween_handler.bounce(result_icon, 2, .5)
		await get_tree().create_timer(2).timeout
		update_chosen_ingredients()

func brew_potion(potion_type, potion_id, potion_name):
	potion_brewed.emit("potion", potion_type, potion_id, 1)
	save_recipe(potion_type, potion_id, potion_name, chosen_ingredients)
	
	var potion = Potions.potions_roster[potion_type][potion_id]
	
	for i in chosen_panels:
		i.get_child(0).texture = default_ingredient_icon
		i.get_child(0).modulate.a = Color.WHITE.a / 2
	
	for ingredient in chosen_ingredients:
		if Ingredients.ingredients_roster[ingredient]["stats_discovered"] == false:
			Ingredients.ingredients_roster[ingredient]["stats_discovered"] = true
	
	potion_name_label.text = potion["name"]
	result_icon.modulate = Color.WHITE
		
	chosen_ingredients.clear()
	for i in chosen_panels:
		if i.has_meta("ingredient"):
			i.remove_meta("ingredient")
	
	await get_tree().create_timer(.2).timeout
	spawn_ingredients()
	spawn_recipes()
