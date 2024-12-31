extends EventScene

@onready var interactable_npc_train = $Train/InteractableNPC_Train
@onready var animations = $AnimationPlayer

func _ready():
	await get_tree().create_timer(.1).timeout
	interactable_npc_train.finished.connect(interact_finished)

func interact_finished():
	animations.play("roll_out")
	await animations.animation_finished
	finished.emit()
