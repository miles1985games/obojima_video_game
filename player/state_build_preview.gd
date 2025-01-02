extends Node2D

@export_enum ("side", "front") var view: String
var active_preview: Sprite2D

func _ready():
	await get_tree().create_timer(.1).timeout

func _process(delta):
	owner.out_ui.emit()

func _physics_process(delta):
	if active_preview == null:
		active_preview = spawn_preview()

	if active_preview != null:
		var mouse_pos = get_global_mouse_position()
		active_preview.global_position = mouse_pos
		
		if owner.get_parent() is Location:
			var location = owner.get_parent()
			if location.ground_tilemap != null:
				var map: TileMapLayer = location.ground_tilemap
				if map.get_used_cells().has(map.local_to_map(active_preview.global_position)):
					var cell = map.local_to_map(active_preview.global_position)
					var snapped_pos: Vector2 = map.map_to_local(cell)
					active_preview.global_position = snapped_pos
					
					if Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT):
						owner.inventory.remove_from_inventory("decor", null, owner.preview_item)
						var scene: PackedScene = Decor.decor_roster[owner.preview_item]["scene"]
						var new_decor: DecorObject = scene.instantiate()
						new_decor.view = view
						new_decor.global_position = snapped_pos
						active_preview.queue_free()
						owner.preview_item = ""
						location.add_child(new_decor)
						owner.state_machine.state = "default"
	
	var input = get_input()
	owner.velocity = input * owner.current_movespeed * delta
	owner.move_and_slide()
	
	owner.animate_movement(input)

func get_input():
	var input_direction = Input.get_vector("left", "right", "up", "down")
	return input_direction

func spawn_preview() -> Sprite2D:
	if !owner.preview_item.is_empty():
		var new_preview = Sprite2D.new()
		new_preview.texture = Decor.decor_roster[owner.preview_item][view + "_sprite"]
		new_preview.modulate = Color.GREEN
		new_preview.modulate.a *= 0.5
		add_child(new_preview)
		
		return new_preview
	else: return null

func _input(event):
	if event.is_action_pressed("rotate"):
		if view == "side":
			view = "front"
		elif view == "front":
			view = "side"

		if active_preview != null:
			active_preview.queue_free()
