extends CharacterBody2D
class_name Player

@onready var sprite = $Sprite

var current_movespeed: float = 5000.0

func _physics_process(delta):
	var input = get_input()
	velocity = input * current_movespeed * delta
	move_and_slide()
	
	animate_movement(input)

func get_input():
	# -- DIRECTIONAL INPUT -- #
	var input_direction = Input.get_vector("left", "right", "up", "down")
	return input_direction

func animate_movement(vector):
	if vector.x > 0:
		sprite.play("walk_right")
	elif vector.x < 0:
		sprite.play("walk_left")
	elif vector.y > 0:
		sprite.play("walk_down")
	elif vector.y < 0:
		sprite.play("walk_up")
	elif vector == Vector2.ZERO:
		sprite.stop()
		sprite.frame = 1
