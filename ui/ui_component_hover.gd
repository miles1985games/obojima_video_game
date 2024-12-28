extends Node2D
class_name UIHoverComponent

var default_scale: Vector2
var target: Control

@export var duration: float
@export var scale_value: Vector2

# Called when the node enters the scene tree for the first time.
func _ready():
	target = get_parent()
	
	call_deferred("setup")


func setup():
	default_scale = target.scale
	target.mouse_entered.connect(mouse_entered)
	target.mouse_exited.connect(mouse_exited)
	target.pivot_offset = target.size / 2

func mouse_entered():
	var new_tween = create_tween()
	new_tween.tween_property(target, "scale", default_scale * scale_value, duration)

func mouse_exited():
	var new_tween = create_tween()
	new_tween.tween_property(target, "scale", default_scale, duration)
