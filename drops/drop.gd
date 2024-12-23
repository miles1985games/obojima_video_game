extends CharacterBody2D
class_name Drop

@export var type: String
@export var subtype: String
@export var item: String

var current_speed: float = 0.0
var acceleration: float = 500.0
var max_speed: float = 5000.0
@export_enum ("idle", "moving") var state: String

@onready var sprite = $Sprite2D

func _ready():
	match type:
		"ingredient":
			sprite.texture = Ingredients.ingredients_roster[item]["icon"]

func _physics_process(delta):
	if state == "moving":
		var target = global_position.direction_to(World.active_player.global_position)
		velocity = current_speed * target * delta
		move_and_slide()
		current_speed = clamp(current_speed + acceleration, 0, max_speed)

func move_area_body_entered(body):
	if body is Player and state == "idle":
		state = "moving"

func pickup_area_body_entered(body):
	if body is Player:
		body.inventory.add_to_inventory(type, subtype, item, 1)
		queue_free()
