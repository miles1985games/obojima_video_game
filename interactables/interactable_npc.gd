extends Interactable
class_name InteractableNPC

@export var dialogue: PackedStringArray

@export var quest_id: String
var quest_node: PackedScene = preload("res://npc/quest.tscn")

signal dialogue_checked

func _ready() -> void:
	if !quest_id.is_empty():
		create_quest(quest_id)

func create_quest(id):
	var quest_info = NpcInfo.quest_roster[quest_id]
	
	var new_quest = quest_node.instantiate()

	new_quest.quest_id = quest_id
	new_quest.needed_item_type = quest_info["item_type"]
	new_quest.reward_type = quest_info["reward_type"]
	new_quest.dialogue = quest_info["dialogue"]
	new_quest.reward_dialogue = quest_info["reward_dialogue"]
	
	#find random item needing to be delivered
	if quest_info["item"] == null:
		new_quest.needed_item = find_random_item(new_quest.needed_item_type)
	else:
		new_quest.needed_item = quest_info["item"]
	
	#find amount of items needed, random 1 to 3
	if quest_info["amount"] == null:
		new_quest.amount_needed = randi_range(1,3)
	else:
		new_quest.amount_needed = quest_info["amount"]
	
	#find random reward and reward subtype, like a combat potion
	if quest_info["reward"] == null:
		var reward = find_random_reward(new_quest.reward_type)
		new_quest.reward_subtype = reward[0]
		new_quest.reward = reward[1]
	else:
		new_quest.reward_subtype = quest_info["reward_subtype"]
		new_quest.reward = quest_info["reward"]
	
	add_child(new_quest)

func find_random_item(type) -> String:
	var item
	match type:
		"ingredient":
			item = Ingredients.ingredients_roster.keys().pick_random()
	return item

func find_random_reward(type) -> Array:
	var subtype
	var reward
	match type:
		"potion":
			subtype = Potions.potions_roster.keys().pick_random()
			reward = Potions.potions_roster[subtype].keys().pick_random()
	
	return [subtype, reward]

func check_dialogue(check):
	if has_method(check):
		call(check)

func interact_finished():
	pass
