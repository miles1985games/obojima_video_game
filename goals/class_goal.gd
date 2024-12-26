extends Node2D
class_name Goal

@export var goal_name: String
var completable: bool = false

var check_icon = preload("res://assets/ui/check_icon.png")

signal trigger_alert

func _ready() -> void:
	await get_tree().create_timer(.1).timeout
	trigger_alert.connect(World.alert_ui.spawn_alert)

func complete():
	completable = false
	print("goal complete")
