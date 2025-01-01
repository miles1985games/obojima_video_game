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
	find_quest_info()

func find_quest_info() -> void:
	var quest_info = NpcInfo.quest_roster[quest_id]
	needed_item_type = quest_info["item_type"]
	reward_type = quest_info["reward_type"]
	dialogue = quest_info["dialogue"]
	reward_dialogue = quest_info["reward_dialogue"]
	
	#find random item needing to be delivered
	if quest_info["item"] == null:
		needed_item = find_random_item(needed_item_type)
	else:
		needed_item = quest_info["item"]
	
	#find amount of items needed, random 1 to 3
	if quest_info["amount"] == null:
		amount_needed = randi_range(1,3)
	else:
		amount_needed = quest_info["amount"]
	
	#find random reward and reward subtype, like a combat potion
	if quest_info["reward"] == null:
		var r = find_random_reward(reward_type)
		reward_subtype = r[0]
		reward = r[1]
		reward_name = r[2]
	else:
		reward_subtype = quest_info["reward_subtype"]
		reward = quest_info["reward"]

func find_random_item(type) -> String:
	var item
	match type:
		"ingredient":
			item = Ingredients.ingredients_roster.keys().pick_random()
	return item

func find_random_reward(type) -> Array:
	var subtype
	var reward
	var n
	match type:
		"potion":
			subtype = Potions.potions_roster.keys().pick_random()
			reward = Potions.potions_roster[subtype].keys().pick_random()
			n = Potions.potions_roster[subtype][reward]["name"]
	
	return [subtype, reward, n]

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
