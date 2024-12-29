extends Location

func _ready():
	await get_tree().create_timer(.5).timeout
	World.location_handler.active_location = self
