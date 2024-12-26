extends Node2D

var state_machine: Node2D

var nav_ready = false

func _ready():
	state_machine = get_parent()
	
	await get_tree().create_timer(.1).timeout
	owner.nav_agent.navigation_finished.connect(target_reached)
	nav_ready = true

func _physics_process(delta):
	if nav_ready and owner.nav_agent.target_position != null:
		if owner.nav_agent.is_navigation_finished():
			return
		
		var direction = owner.global_position.direction_to(owner.nav_agent.get_next_path_position())
		owner.velocity = direction * owner.current_movespeed * delta
		owner.move_and_slide()
		
		animate_movement(direction)

func animate_movement(vector):
	if vector.x > 0:
		owner.sprite.play("walk_right")
	elif vector.x < 0:
		owner.sprite.play("walk_left")
	elif vector.y > 0:
		owner.sprite.play("walk_down")
	elif vector.y < 0:
		owner.sprite.play("walk_up")
	elif vector == Vector2.ZERO:
		owner.sprite.stop()
		owner.sprite.frame = 1

func target_reached():
	state_machine.state = "idle"