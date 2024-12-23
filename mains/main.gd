extends Control

@onready var start_screen = $StartScreen

var game_scene = preload("res://mains/game.tscn")

# Called when the node enters the scene tree for the first time.
func _ready():
	start_screen.demo_pressed.connect(start_demo)


func start_demo():
	start_screen.hide()
	
	var new_game = game_scene.instantiate()
	add_child(new_game)

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("quick_quit"):
		get_tree().quit()
