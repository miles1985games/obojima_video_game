extends DiscoverGoal
class_name DiscoverIngredientsGoal

var current_index: int = 0
var goal_increments: Array = [3,10,20]

func _ready() -> void:
	super()
	if goal_increments.size() > current_index:
		goal_amount = goal_increments[current_index]
	
	goal_name = "Discover " + str(goal_amount) + " ingredients"
	
	await get_tree().create_timer(.1).timeout
	World.active_player.inventory.ingredient_discovered.connect(ingredient_discovered)

func ingredient_discovered(_text, _icon):
	current_amount += 1
	
	#if player has hit the goal
	if current_amount >= goal_amount:
		if completable == false:
			trigger_alert.emit("Goal Complete!", check_icon)
		completable = true

func complete():
	super()
	current_index += 1
	if goal_increments.size() > current_index:
		goal_amount = goal_increments[current_index]
		goal_name = "Discover " + str(goal_amount) + " ingredients"
