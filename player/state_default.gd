extends Node2D


func _physics_process(delta):
	var input = get_input()
	owner.velocity = input * owner.current_movespeed * delta
	owner.move_and_slide()
	
	animate_movement(input)

func get_input():
	# -- DIRECTIONAL INPUT -- #
	var input_direction = Input.get_vector("left", "right", "up", "down")
	return input_direction

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
