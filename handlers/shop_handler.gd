extends Node2D

var shop_slots: Array = []
signal slots_changed

# Called when the node enters the scene tree for the first time.
func _ready():
	World.shop_handler = self

func add_slot(slot):
	if !shop_slots.has(slot):
		shop_slots.append(slot)
	slots_changed.emit()

func remove_slot(slot):
	if shop_slots.has(slot):
		shop_slots.erase(slot)
	slots_changed.emit()

func potion_purchased(npc, slot):
	if is_instance_valid(World.active_player):
		World.active_player.current_money += 5
	
	slot.potion_type = ""
	slot.potion = ""
	slot.populate()
	
	npc.state_machine.state = "idle"
	npc.targeted_slot = null
