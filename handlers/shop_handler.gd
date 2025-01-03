extends Node2D

var shop_slots: Array = []

# Called when the node enters the scene tree for the first time.
func _ready():
	World.shop_handler = self

func add_slot(slot):
	if !shop_slots.has(slot):
		shop_slots.append(slot)

func remove_slot(slot):
	if shop_slots.has(slot):
		shop_slots.erase(slot)
