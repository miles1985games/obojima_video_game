extends Node2D

var npc: PackedScene = preload("res://npc/npc.tscn")

# Called when the node enters the scene tree for the first time.
func _ready():
	World.npc_handler = self
