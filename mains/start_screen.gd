extends Control

@onready var demo_button = $MarginContainer/VBoxContainer/DemoButton
signal demo_pressed

func demo_button_pressed():
	demo_button.disabled = true
	demo_pressed.emit()
