extends Node2D

var text_scroll_speed: float = 1

# Called when the node enters the scene tree for the first time.
func _ready():
	World.settings_handler = self
