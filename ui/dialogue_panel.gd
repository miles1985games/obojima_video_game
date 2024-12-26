extends PanelContainer

@onready var label: Label = %Label
@onready var next_button: Button = %NextButton
@onready var quest_delivery_button: Button = %QuestDeliveryButton

var quest: Node2D

var dialogue: Array

var dialogue_index: int = 0

signal dialogue_finished
signal quest_complete

# Called when the node enters the scene tree for the first time.
func _ready():
	quest_delivery_button.hide()
	if quest != null:
		dialogue = quest.dialogue
		
		var item_name
		match quest.needed_item_type:
			"ingredient":
				item_name = Ingredients.ingredients_roster[quest.needed_item]["name"]
		
		quest_delivery_button.text = "Deliver: " + str(quest.amount_needed) + " " + item_name + \
		" | " + "Reward: " + quest.reward_name
		
		quest_complete.connect(quest.complete_quest)
	
	if not dialogue.is_empty():
		label.text = dialogue[dialogue_index]

func next_button_pressed():
	dialogue_index += 1
	
	if dialogue_index < dialogue.size():
		label.text = dialogue[dialogue_index]
	else:
		dialogue_finished.emit()
		queue_free()
	
	if dialogue_index + 1 >= dialogue.size():
		if quest != null:
			check_quest_delivery()
		next_button.text = "Finish"

func check_quest_delivery():
	var needed_item = quest.needed_item
	var amount_needed = quest.amount_needed
	var inventory = World.active_player.inventory
	
	var item_amount: int = 0
	for i in inventory.get_children():
		if i.item == needed_item:
			item_amount += 1
	
	if item_amount >= amount_needed:
		quest_delivery_button.disabled = false
	quest_delivery_button.show()

func quest_delivery_button_pressed() -> void:
	quest_delivery_button.hide()
	show_reward_dialogue()
	quest_complete.emit()
	
func show_reward_dialogue():
	dialogue_index = -1
	dialogue = quest.reward_dialogue
	quest = null
	next_button_pressed()