extends PanelContainer

@onready var icon: TextureRect = %Icon
@onready var label: Label = %Label
@onready var ingredients_container: HBoxContainer = %IngredientsContainer
@onready var button: Button = %Button

var potion_type: String
var potion_id: String
var ingredients: Array

signal recipe_pressed

func _ready() -> void:
	var potion: Dictionary = Potions.potions_roster[potion_type][potion_id]
	
	label.text = potion["name"]
	icon.texture = potion["icon"]
	
	var index = 0
	for i in ingredients_container.get_children():
		var ingredient: Dictionary = Ingredients.ingredients_roster[ingredients[index]]
		i.texture = ingredient["icon"]
		index += 1
	
	var inventory = World.active_player.inventory
	var ingredients_held: int = 0
	for ingredient in ingredients:
		for i in inventory.get_children():
			if i.item == ingredient:
				ingredients_held += 1
	
	if ingredients_held >= ingredients.size():
		button.disabled = false

func button_pressed() -> void:
	recipe_pressed.emit(ingredients)
