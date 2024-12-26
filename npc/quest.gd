extends Node2D
class_name Quest

var quest_id: String

var dialogue: Array
var reward_dialogue: Array

var needed_item_type: String
var needed_item_subtype = null
var needed_item: String

var amount_needed: int
var amount_delivered: int = 0

var reward_type: String
var reward_subtype: String
var reward: String
var reward_name: String

func _ready() -> void:
	match reward_type:
		"potion":
			reward_name = Potions.potions_roster[reward_subtype][reward]["name"]

func complete_quest():
	var inventory = World.active_player.inventory
	
	var amount_delivered: int = 0
	print("amount needed: " + str(amount_needed))
	while amount_delivered < amount_needed:
		for i in inventory.get_children():
			if i.item == needed_item:
				inventory.remove_from_inventory(needed_item_type, needed_item_subtype, needed_item)
				amount_delivered += 1
				print("amount delivered: " + str(amount_delivered))
	
	inventory.add_to_inventory(reward_type, reward_subtype, reward, 1)
	get_parent().quest_id = ""
	
	await get_tree().create_timer(.1).timeout
	queue_free()
