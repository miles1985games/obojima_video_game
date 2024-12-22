extends Node

var active_player

var location_handler: Node2D

var locations_roster: Dictionary = {
	"town" = preload("res://locations/town.tscn"),
	"home_interior" = preload("res://locations/home_interior.tscn"),
}
