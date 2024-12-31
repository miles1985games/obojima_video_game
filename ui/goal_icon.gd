extends PanelContainer

@onready var title_label: RichTextLabel = %TitleLabel
@onready var current_amount: Label = %CurrentAmount
@onready var goal_amount: Label = %GoalAmount
@onready var complete_button: Button = %CompleteButton

var goal: Node2D

var seen: bool = false

signal complete_goal

func _ready() -> void:
	title_label.visible_characters = 0
	if goal != null:
		update()
	
	complete_goal.connect(goal.complete)

func complete_button_pressed() -> void:
	await World.tween_handler.snap_spin(self)
	complete_goal.emit()

func reset():
	seen = false

func update():
	var old_name = title_label.text
	if old_name != goal.goal_name:
		reset()
	title_label.text = goal.goal_name
	if goal is DiscoverGoal:
		current_amount.text = str(goal.current_amount)
		goal_amount.text = str(goal.goal_amount)
		
	if goal.completable:
		complete_button.disabled = false
	else:
		complete_button.disabled = true
	
	if !seen:
		seen = true
		World.tween_handler.text_crawl(title_label)
