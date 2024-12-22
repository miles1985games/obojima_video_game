extends CanvasLayer

@onready var ingredients_button = %IngredientsButton
@onready var ingredients_container = %IngredientsContainer
@onready var ingredients_grid = %IngredientsGrid
@onready var active_tab_label = %ActiveTabLabel
@onready var detailed_name = %Name
@onready var icon = %Icon
@onready var combat_label = %CombatLabel
@onready var utility_label = %UtilityLabel
@onready var whimsy_label = %WhimsyLabel
@onready var details = %Details

var ingredient_icon = preload("res://ui/ingredient_icon.tscn")

func _ready():
	hide()

func _input(event):
	if event.is_action_pressed("inventory"):
		if visible and World.active_player.state_machine.state == "ui": 
			hide()
			World.active_player.state_machine.state = "default"
		else:
			show()
			World.active_player.state_machine.state = "ui"
			spawn_ingredient_icons()

func ingredients_button_pressed():
	active_tab_label.text = "Ingredients"
	spawn_ingredient_icons()
	ingredients_container.show()

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
