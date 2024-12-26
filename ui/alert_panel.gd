extends PanelContainer

func _ready():
	await get_tree().create_timer(5).timeout
	await World.tween_handler.fade_out(self, .5)
	queue_free()

func populate(alert_text, icon):
	$HBoxContainer/Label.text = alert_text
	$HBoxContainer/TextureRect.texture = icon
