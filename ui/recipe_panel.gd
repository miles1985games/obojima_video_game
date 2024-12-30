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
	var inventory = World.active_player.inventory
	var ingredients_held: int = 0
	for i in ingredients_container.get_children():
		var ingredient: Dictionary = Ingredients.ingredients_roster[ingredients[index]]
		i.texture = ingredient["icon"]
		index += 1
		
		var key = Ingredients.ingredients_roster.find_key(ingredient)
		var inv_index: int = 0
		for n in inventory.get_children():
			if n.item == key:
				ingredients_held += 1
			else:
				inv_index += 1
		
		if inv_index >= inventory.get_child_count():
			i.modulate.a *= 0.5
			print(i.modulate.a)

func button_pressed() -> void:
	recipe_pressed.emit(ingredients)
