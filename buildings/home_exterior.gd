extends StaticBody2D

signal doorway_entered

func _ready():
	if World.location_handler != null:
		doorway_entered.connect(World.location_handler.change_location)

func doorway_body_entered(body):
	if body is Player:
		doorway_entered.emit("home_interior")
