extends PanelContainer

@export var potion: String
@onready var icon = $Icon

var default_icon = preload("res://assets/ui/potions_icon.png")

func _ready():
	populate()

func populate():
	if !potion.is_empty():
		icon.texture = Potions.potions_roster[potion]["icon"]
	else:
		icon.texture = default_icon
