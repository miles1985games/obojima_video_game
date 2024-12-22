extends CharacterBody2D
class_name Player

@onready var sprite = $Sprite
@onready var state_machine = $StateMachine

var current_movespeed: float = 5000.0

func _ready():
	await get_tree().create_timer(.5).timeout
	World.active_player = self
