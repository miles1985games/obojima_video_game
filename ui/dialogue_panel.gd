extends PanelContainer

@onready var label: RichTextLabel = %Label
@onready var next_button: Button = %NextButton
@onready var quest_delivery_button: Button = %QuestDeliveryButton

var interactable: Node2D

var quest: Node2D

var dialogue: Array

var dialogue_index: int = 0

signal dialogue_finished
signal quest_complete

# Called when the node enters the scene tree for the first time.
func _ready():
	label.visible_characters = 0
	quest_delivery_button.hide()
	if quest != null:
		dialogue = quest.dialogue
		
		var item_name
		match quest.needed_item_type:
			"ingredient":
				item_name = Ingredients.ingredients_roster[quest.needed_item]["name"]
		
		quest_delivery_button.text = "Deliver: " + str(quest.amount_needed) + " " + item_name
		
		quest_complete.connect(quest.complete_quest)
	
	if not dialogue.is_empty():
		label.text = dialogue[dialogue_index]
		World.tween_handler.text_crawl(label)
	
	if interactable != null and interactable.has_method("interact_finished"):
		dialogue_finished.connect(interactable.interact_finished)

func advance_dialogue(index):
	dialogue_index = index - 1
	next_button_pressed()

func next_button_pressed():
	dialogue_index += 1
	
	if (dialogue_index < dialogue.size()) and \
	!dialogue[dialogue_index].is_empty():
		var new_dialogue: String = dialogue[dialogue_index]
		if new_dialogue.contains("/"):
			var modified_dialogue = new_dialogue.erase(0,1)
			if interactable != null:
				if !interactable.dialogue_checked.is_connected(advance_dialogue):
					interactable.dialogue_checked.connect(advance_dialogue)
				interactable.check_dialogue(modified_dialogue)
		else:
			label.text = new_dialogue
			World.tween_handler.text_crawl(label)
	else:
		dialogue_finished.emit()
		queue_free()
	
	if (dialogue_index + 1 >= dialogue.size()) or dialogue[dialogue_index+1].is_empty():
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
	next_button.text = "No"
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
