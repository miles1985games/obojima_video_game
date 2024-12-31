extends PanelContainer

@onready var label = $HBoxContainer/Label

func _on_button_pressed():
	World.active_player.state_machine.state = "default"
	queue_free()
