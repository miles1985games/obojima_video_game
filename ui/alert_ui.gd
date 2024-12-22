extends CanvasLayer

var alert_panel = preload("res://ui/alert_panel.tscn")
var interact_panel = preload("res://ui/interact_panel.tscn")

@onready var margin_container = $MarginContainer
@onready var alert_container = $MarginContainer/AlertContainer

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
