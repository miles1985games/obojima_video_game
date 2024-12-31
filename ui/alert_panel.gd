extends PanelContainer

@onready var label = $HBoxContainer/Label
@onready var texture_rect = $HBoxContainer/TextureRect


func _ready():
	World.tween_handler.snap_spin(self)
	await get_tree().create_timer(5).timeout
	await World.tween_handler.fade_out(self, .5)
	queue_free()

func populate(alert_text, icon):
	label.text = alert_text
	texture_rect.texture = icon
