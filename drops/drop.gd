extends CharacterBody2D
class_name Drop

@export var type: String
@export var subtype: String
@export var item: String

var current_speed: float = 0.0
var acceleration: float = 500.0
var max_speed: float = 10000.0
@export_enum ("dropping", "idle", "moving") var state: String

@onready var sprite = $Sprite2D

func _ready():
	state = "dropping"
	match type:
		"ingredient":
			sprite.texture = Ingredients.ingredients_roster[item]["icon"]
		"key_item":
			sprite.texture = Items.key_items_roster[item]["sprite"]

func _physics_process(delta):
	var target
	if state == "dropping":
		drop_animation()
		state = "idle"
	elif state == "moving":
		target = global_position.direction_to(World.active_player.global_position)
		velocity = current_speed * target * delta
		current_speed = clamp(current_speed + acceleration, 0, max_speed)
	move_and_slide()

func drop_animation():
	var total_distance = Vector2(0, 50)
	World.tween_handler.drop(self, total_distance, 2)

func move_area_body_entered(body):
	if body is Player and state == "idle":
		state = "moving"

func pickup_area_body_entered(body):
	if body is Player:
		body.inventory.add_to_inventory(type, subtype, item, 1)
		queue_free()
