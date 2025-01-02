extends Node2D
class_name DecorObject

@export var item: String
@export_enum ("side", "front") var view: String
@export var front: Node2D
@export var side: Node2D

func _ready():
	if view == "side" and side != null:
		front.process_mode = Node.PROCESS_MODE_DISABLED
		front.hide()
		side.show()
	elif view == "front" and front != null:
		side.process_mode = Node.PROCESS_MODE_DISABLED
		side.hide()
		front.show()