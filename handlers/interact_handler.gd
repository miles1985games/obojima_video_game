extends Node2D

var in_range_interactables: Array = []
var targeted_interactable
@onready var arrow = $Arrow

signal interacted
signal npc_interacted
signal cauldron_interacted
signal slot_interacted

func _ready():
	World.interact_handler = self
	
	await get_tree().create_timer(.1).timeout
	interacted.connect(World.alert_ui.spawn_interact)
	cauldron_interacted.connect(World.potion_ui.open)
	npc_interacted.connect(World.alert_ui.interact_with_npc)
	slot_interacted.connect(World.shop_slot_ui.show_ui)

func add_interactable(interactable):
	in_range_interactables.append(interactable)

func remove_interactable(interactable):
	if in_range_interactables.has(interactable):
		in_range_interactables.erase(interactable)
		if targeted_interactable == interactable:
			targeted_interactable = null

func _process(_delta):
	if in_range_interactables.size() > 0:
		var closest = in_range_interactables[0]
		for i in in_range_interactables:
			if World.active_player.global_position.distance_to(i.global_position) < \
			World.active_player.global_position.distance_to(closest.global_position):
				closest = i
		targeted_interactable = closest
		move_arrow()
	else:
		arrow.hide()

func move_arrow():
	arrow.global_position = Vector2(targeted_interactable.global_position.x, targeted_interactable.global_position.y - 50)
	arrow.show()

func _input(event):
	if targeted_interactable != null and World.active_player.state_machine.state == "default":
		if event.is_action_pressed("interact") and get_global_mouse_position().distance_to(targeted_interactable.global_position) < 50:
			interact()

func interact():
	if targeted_interactable is Cauldron:
		cauldron_interacted.emit()
	elif targeted_interactable is ShopSlot:
		slot_interacted.emit(targeted_interactable)
	elif targeted_interactable is DigSpot:
		var key_items = World.active_player.key_items.get_children()
		var index = 0
		for key in key_items:
			if key.item == "shovel":
				targeted_interactable.dig()
			else:
				index += 1
		if index >= key_items.size():
			interacted.emit(targeted_interactable.interact_text)
	elif targeted_interactable is NPC:
		npc_interacted.emit(targeted_interactable)
	else:
		interacted.emit(targeted_interactable.interact_text)
