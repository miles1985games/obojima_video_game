extends Node2D

var active_scene

# Called when the node enters the scene tree for the first time.
func _ready():
	World.scene_handler = self

func change_scene(new_scene):
	pass
