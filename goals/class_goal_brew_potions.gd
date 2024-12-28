extends DiscoverGoal
class_name BrewPotionsGoal

var current_index: int = 0
var goal_increments: Array = [5,10,15]

func _ready() -> void:
	super()
	if goal_increments.size() > current_index:
		goal_amount = goal_increments[current_index]
	
	goal_name = "Brew " + str(goal_amount) + " potions"
	
	await get_tree().create_timer(.1).timeout
	World.potion_ui.potion_brewed.connect(potion_brewed)

func potion_brewed(subtype, type, id, amount):
	current_amount += 1
	
	#if player has hit the goal
	if current_amount >= goal_amount:
		if completable == false:
			trigger_alert.emit("Goal Complete!", check_icon)
		completable = true

func complete():
	current_index += 1
	if goal_increments.size() > current_index:
		goal_amount = goal_increments[current_index]
		goal_name = "Brew " + str(goal_amount) + " potions"
