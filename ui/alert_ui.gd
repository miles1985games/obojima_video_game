extends CanvasLayer

var alert_panel = preload("res://ui/alert_panel.tscn")
var interact_panel = preload("res://ui/interact_panel.tscn")
var dialogue_panel = preload("res://ui/dialogue_panel.tscn")

@onready var margin_container = $MarginContainer
@onready var alert_container = $MarginContainer/AlertContainer
@onready var dialogue_container = $MarginContainer/DialogueContainer

func _ready():
	World.alert_ui = self

func spawn_alert(text, icon):
	var new_panel = alert_panel.instantiate()
	alert_container.add_child(new_panel)
	new_panel.populate(text, icon)

func spawn_interact(text):
	World.active_player.state_machine.state = "ui"
	var new_panel = interact_panel.instantiate()
	margin_container.add_child(new_panel)
	new_panel.label.text = text

func interact_with_npc(interactable):
	if !interactable.quest_id.is_empty():
		var quest: Node2D
		for i in interactable.get_children():
			if i is Quest:
				quest = i
		spawn_quest_dialogue(quest)
	elif !interactable.dialogue.is_empty():
		spawn_dialogue(interactable)
	else:
		spawn_interact(interactable.interact_text)

func spawn_quest_dialogue(quest):
	World.active_player.state_machine.state = "ui"
	var new_panel = dialogue_panel.instantiate()
	new_panel.quest = quest
	dialogue_container.add_child(new_panel)
	new_panel.dialogue_finished.connect(finish_dialogue)

func spawn_dialogue(interactable_npc):
	World.active_player.state_machine.state = "ui"
	var new_panel = dialogue_panel.instantiate()
	new_panel.dialogue = interactable_npc.dialogue
	dialogue_container.add_child(new_panel)
	new_panel.dialogue_finished.connect(finish_dialogue)

func finish_dialogue():
	World.active_player.state_machine.state = "default"
