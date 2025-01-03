extends Node

var active_player: CharacterBody2D

var location_handler: Node2D
var interact_handler: Node2D
var tween_handler: Node2D
var goal_handler: Node2D
var time_handler: CanvasModulate
var event_handler: Node2D
var settings_handler: Node2D
var ingredient_handler: Node2D
var npc_handler: Node2D

var alert_ui: CanvasLayer
var potion_ui: CanvasLayer

var locations_roster: Dictionary = {
	"home" = preload("res://locations/home.tscn"),
	"home_interior" = preload("res://locations/home_interior.tscn"),
	"head_witch_house_interior" = preload("res://locations/head_witch_house_interior.tscn"),
}
