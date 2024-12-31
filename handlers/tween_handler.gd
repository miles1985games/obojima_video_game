extends Node2D

var active_nodes: Array = []

func _ready():
	World.tween_handler = self

func drop(node, distance, duration):
	var new_tween = create_tween()
	new_tween.tween_property(node, "position", node.position + distance, duration).set_trans(Tween.TRANS_BOUNCE).set_ease(Tween.EASE_OUT)
	await new_tween.finished
	return true

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

func fade_in(node, duration):
	node.modulate = Color.TRANSPARENT
	var new_tween = create_tween()
	new_tween.tween_property(node, "modulate", Color.WHITE, duration)
	await new_tween.finished
	
	return true

func snap_spin(node):
	if !active_nodes.has(node):
		active_nodes.append(node)
		if node is Control:
			node.pivot_offset = node.size / 2
		
		var initial_rot = node.rotation
		var initial_scl = node.scale
		
		var rot_tween_1 = create_tween()
		rot_tween_1.tween_property(node, "rotation", initial_rot + .1, .05)
		var scale_tween_1 = create_tween()
		scale_tween_1.tween_property(node, "scale", initial_scl - Vector2(.2,.1), .05)
		await rot_tween_1.finished
		var rot_tween_2 = create_tween()
		rot_tween_2.tween_property(node, "rotation", initial_rot - .1, .1)
		var scale_tween_2 = create_tween()
		scale_tween_2.tween_property(node, "scale", initial_scl + Vector2(.1,.05), .1)
		await rot_tween_2.finished
		var rot_tween_3 = create_tween()
		rot_tween_3.tween_property(node, "rotation", initial_rot, .5).set_trans(Tween.TRANS_BOUNCE).set_ease(Tween.EASE_OUT)
		var scale_tween_3 = create_tween()
		scale_tween_3.tween_property(node, "scale", initial_scl, .5).set_trans(Tween.TRANS_BOUNCE).set_ease(Tween.EASE_OUT)
		await rot_tween_3.finished
		active_nodes.erase(node)
	return true

func text_crawl(node: RichTextLabel) -> bool:
	node.visible_characters = 0
	var speed = World.settings_handler.text_scroll_speed
	var tween = create_tween()
	tween.tween_property(node, "visible_characters", node.get_total_character_count(), speed).set_ease(Tween.EASE_OUT)
	await tween.finished
	
	return true
