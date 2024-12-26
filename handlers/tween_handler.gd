extends Node2D

func _ready():
	World.tween_handler = self

func bounce(node, intensity, duration):
	if node is Control:
		node.pivot_offset = node.size / 2
	
	var old_scale = node.scale
	
	var new_tween = create_tween()
	new_tween.tween_property(node, "scale", node.scale * (1 + intensity*.1), .1).set_ease(Tween.EASE_OUT)
	await new_tween.finished
	
	var new_tween_2 = create_tween()
	new_tween_2.tween_property(node, "scale", old_scale, duration).set_trans(Tween.TRANS_BOUNCE).set_ease(Tween.EASE_OUT)
	await new_tween_2.finished
	
	return true

func fade_out(node, duration):
	var new_tween = create_tween()
	new_tween.tween_property(node, "modulate", Color.TRANSPARENT, duration)
	await new_tween.finished
	
	return true
