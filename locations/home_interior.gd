extends Location

signal doorway_entered

func _ready():
	doorway_entered.connect(World.location_handler.change_location)

func exit_doorway_body_entered(body):
	if body is Player:
		doorway_entered.emit("town")
