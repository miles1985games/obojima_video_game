extends Interactable
class_name ShopSlot

@export var potion_type: String
@export var potion: String
@export var icon: TextureRect
@export var purchase_area: Area2D

var default_icon = preload("res://assets/ui/potions_icon.png")

signal potion_purchased

func _ready():
	purchase_area.body_entered.connect(body_entered)
	populate()
	
	await get_tree().create_timer(.1).timeout
	potion_purchased.connect(World.shop_handler.potion_purchased)

func populate():
	if !potion.is_empty():
		icon.texture = Potions.potions_roster[potion_type][potion]["icon"]
	else:
		icon.texture = default_icon

func body_entered(body):
	if body is Traveler and body.targeted_slot == self:
		potion_purchased.emit(body, self)
