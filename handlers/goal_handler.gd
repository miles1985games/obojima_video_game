extends Node2D

var completed_goals: Array = []

func _ready() -> void:
	World.goal_handler = self
	
	#spawn base goals
	for goal in Goals.goal_roster.keys():
		var new_goal = Goals.goal_roster[goal].new()
		add_child(new_goal)
