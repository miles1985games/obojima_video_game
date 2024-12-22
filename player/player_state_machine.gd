extends Node2D

@export_enum ("default", "ui") var state: String

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	for s in get_children():
		if s.name == state:
			s.process_mode = Node.PROCESS_MODE_INHERIT
		else:
			s.process_mode = Node.PROCESS_MODE_DISABLED
