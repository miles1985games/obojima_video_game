extends StaticBody2D

var interior_scene

signal doorway_entered

# Called when the node enters the scene tree for the first time.
func _ready():
	doorway_entered.connect(World.scene_handler.change_scene)

func doorway_body_entered(body):
	if body is Player:
		doorway_entered.emit(interior_scene)
