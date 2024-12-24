extends CharacterBody2D
class_name Player

@onready var sprite = $Sprite
@onready var state_machine = $StateMachine
@onready var inventory = $Inventory

var current_movespeed: float = 5000.0

signal interactable_entered
signal interactable_exited
signal in_ui
signal out_ui

func _ready():
	World.active_player = self
	await get_tree().create_timer(.1).timeout
	interactable_entered.connect(World.interact_handler.add_interactable)
	interactable_exited.connect(World.interact_handler.remove_interactable)

func interact_area_body_entered(body):
	if body is Interactable:
		interactable_entered.emit(body)

func interact_area_area_entered(area):
	if area is Interactable:
		interactable_entered.emit(area)

func interact_area_body_exited(body):
	if body is Interactable:
		interactable_exited.emit(body)

func interact_area_area_exited(area):
	if area is Interactable:
		interactable_exited.emit(area)
