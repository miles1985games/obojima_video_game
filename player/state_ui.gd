extends Node2D

func _process(delta):
	owner.in_ui.emit()
	owner.sprite.stop()
	owner.sprite.frame = 1
