extends PanelContainer

@onready var title_label: Label = %TitleLabel
@onready var current_amount: Label = %CurrentAmount
@onready var goal_amount: Label = %GoalAmount
@onready var complete_button: Button = %CompleteButton

var goal: Node2D

signal complete_goal

func _ready() -> void:
	if goal != null:
		title_label.text = goal.goal_name
		
		if goal is DiscoverGoal:
			current_amount.text = str(goal.current_amount)
			goal_amount.text = str(goal.goal_amount)
		
		if goal.completable:
			complete_button.disabled = false
		
		complete_goal.connect(goal.complete)

func complete_button_pressed() -> void:
	await World.tween_handler.bounce(self, 1, 1)
	complete_goal.emit()
