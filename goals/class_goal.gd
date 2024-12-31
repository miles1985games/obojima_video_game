extends Node2D
class_name Goal

@export var goal_name: String
var completable: bool = false

var check_icon = preload("res://assets/ui/check_icon.png")
var goals_icon = preload("res://assets/ui/goals_icon.png")

signal trigger_alert

func _ready() -> void:
	await get_tree().create_timer(.1).timeout
	trigger_alert.connect(World.alert_ui.spawn_alert)
	trigger_alert.emit("New Goal: " + goal_name, goals_icon)

func complete():
	completable = false
	print("goal complete")
