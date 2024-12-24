extends PanelContainer

@onready var label = $MarginContainer/HBoxContainer/Label
@onready var next_button = $MarginContainer/HBoxContainer/NextButton

var dialogue: Array

var dialogue_index: int = 0

signal dialogue_finished

# Called when the node enters the scene tree for the first time.
func _ready():
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
		next_button.text = "Finish"
