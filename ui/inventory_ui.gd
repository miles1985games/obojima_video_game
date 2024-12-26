extends CanvasLayer

@onready var inventory_button = %InventoryButton
@onready var inventory_scroll_container = %InventoryScrollContainer
@onready var inventory_grid = %InventoryGrid

@onready var goals_button: Button = %GoalsButton
@onready var goals_scroll_container: ScrollContainer = %GoalsScrollContainer
@onready var goals_grid: GridContainer = %GoalsGrid
@onready var goals_notification: TextureRect = %GoalsNotification

@onready var ingredients_button = %IngredientsButton
@onready var ingredients_scroll_container = %IngredientsScrollContainer
@onready var ingredients_grid = %IngredientsGrid

@onready var potions_button: Button = %PotionsButton
@onready var potions_scroll_container: ScrollContainer = %PotionsScrollContainer
@onready var potions_grid: GridContainer = %PotionsGrid

@onready var active_tab_label = %ActiveTabLabel
@onready var detailed_name = %Name
@onready var icon = %Icon
@onready var stats = %Stats
@onready var combat_label = %CombatLabel
@onready var utility_label = %UtilityLabel
@onready var whimsy_label = %WhimsyLabel
@onready var details = %Details

var ingredient_icon = preload("res://ui/ingredient_icon.tscn")
var goal_icon = preload("res://ui/goal_icon.tscn")
var inventory_icon = preload("res://ui/inventory_icon.tscn")
var potion_icon = preload("res://ui/potion_icon.tscn")

func _ready():
	hide()

func _input(event):
	if event.is_action_pressed("inventory"):
		if visible and World.active_player.state_machine.state == "ui": 
			hide()
			World.active_player.state_machine.state = "default"
		elif World.active_player.state_machine.state == "default":
			show()
			World.active_player.state_machine.state = "ui"
			inventory_button_pressed()

func ingredients_button_pressed():
	reset()
	active_tab_label.text = "Ingredients Encyclopedia"
	spawn_ingredient_icons()
	ingredients_scroll_container.show()

func spawn_ingredient_icons():
	for i in ingredients_grid.get_children():
		i.queue_free()
	for ingredient in Ingredients.ingredients_roster.keys():
		var new_icon = ingredient_icon.instantiate()
		ingredients_grid.add_child(new_icon)
		
		new_icon.ingredient = ingredient
		new_icon.populate()
		
		new_icon.pressed.connect(ingredient_icon_pressed.bind(new_icon.ingredient))

func ingredient_icon_pressed(ingredient):
	combat_label.text = "?"
	utility_label.text = "?"
	whimsy_label.text = "?"
	
	var i = Ingredients.ingredients_roster[ingredient]
	if Ingredients.ingredients_roster[ingredient]["discovered"] == true:
		detailed_name.text = str("[center]") + i["name"] + str("[/center]")
		icon.texture = i["icon"]
		icon.modulate = Color.WHITE
		details.text = i["description"]
		if i["stats_discovered"] == true:
			combat_label.text = "Combat: " + str(i["combat"])
			utility_label.text = "Utility: " + str(i["utility"])
			whimsy_label.text = "Whimsy: " + str(i["whimsy"])
	else:
		detailed_name.text = "[center]Unknown Ingredient[/center]"
		icon.texture = i["icon"]
		icon.modulate = Color.BLACK
		details.text = ""
	
	stats.show()

func reset():
	ingredients_scroll_container.hide()
	goals_scroll_container.hide()
	inventory_scroll_container.hide()
	potions_scroll_container.hide()
	check_goals()
	detailed_name.text = "[center]Click an item to inspect[/center]"
	icon.texture = null
	icon.modulate = Color.WHITE
	stats.hide()
	combat_label.text = "?"
	utility_label.text = "?"
	whimsy_label.text = "?"
	details.text = ""

func inventory_button_pressed():
	reset()
	active_tab_label.text = "Inventory"
	spawn_inventory()
	inventory_scroll_container.show()

func spawn_inventory():
	for i in inventory_grid.get_children():
		i.free()
	var inventory = World.active_player.inventory.get_children()
	for i in inventory:
		var existing = null
		for e in inventory_grid.get_children():
			if e.item == i.item:
				existing = e
		
		if existing != null:
			existing.stack += 1
			existing.populate()
		else:
			var new_icon = inventory_icon.instantiate()
			new_icon.type = i.type
			if i.subtype != null:
				new_icon.subtype = i.subtype
			new_icon.item = i.item
			inventory_grid.add_child(new_icon)
			new_icon.populate()
			new_icon.pressed.connect(inventory_icon_pressed.bind(new_icon))

func inventory_icon_pressed(new_icon):
	match new_icon.type:
		"ingredient":
			ingredient_icon_pressed(new_icon.item)
		"potion":
			potion_icon_pressed(new_icon.subtype, new_icon.item)

func potions_button_pressed() -> void:
	reset()
	active_tab_label.text = "Potions Encyclopedia"
	spawn_potions()
	potions_scroll_container.show()

func spawn_potions():
	for i in potions_grid.get_children():
		i.free()
	
	for potion_type in Potions.potions_roster.keys():
		for potion_id in Potions.potions_roster[potion_type].keys():
			var new_icon = potion_icon.instantiate()
			potions_grid.add_child(new_icon)
			
			new_icon.type = potion_type
			new_icon.id = potion_id
			new_icon.populate()
			
			new_icon.pressed.connect(potion_icon_pressed.bind(new_icon.type, new_icon.id))

func potion_icon_pressed(type, id):
	stats.hide()
	var potion = Potions.potions_roster[type][id]
	if potion["discovered"] == true:
		detailed_name.text = str("[center]") + potion["name"] + str("[/center]")
		icon.texture = potion["icon"]
		icon.modulate = Color.WHITE
		details.text = potion["description"]
	else:
		detailed_name.text = "[center]Unknown Potion[/center]"
		icon.texture = potion["icon"]
		icon.modulate = Color.BLACK
		details.text = ""

func check_goals():
	goals_notification.hide()
	for goal in World.goal_handler.get_children():
		if goal.completable:
			goals_notification.show()

func reset_goals():
	await get_tree().create_timer(.1).timeout
	goals_button_pressed()

func goals_button_pressed() -> void:
	reset()
	active_tab_label.text = "Goals"
	spawn_goals()
	goals_scroll_container.show()

func spawn_goals():
	for i in goals_grid.get_children():
		i.queue_free()
	
	for goal in World.goal_handler.get_children():
		var new_goal_icon = goal_icon.instantiate()
		new_goal_icon.goal = goal
		new_goal_icon.complete_goal.connect(reset_goals)
		goals_grid.add_child(new_goal_icon)
