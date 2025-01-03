extends Interactable
class_name ShopSlot

@export var potion_type: String
@export var potion: String
@export var icon: TextureRect

var default_icon = preload("res://assets/ui/potions_icon.png")

func _ready():
	populate()
	await get_tree().create_timer(.1).timeout

func populate():
	if !potion.is_empty():
		icon.texture = Potions.potions_roster[potion_type][potion]["icon"]
	else:
		icon.texture = default_icon
