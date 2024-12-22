extends Button

var type: String
var item: String
var stack: float = 1.0

func populate():
	match type:
		"ingredient":
			icon = Ingredients.ingredients_roster[item]["icon"]
			text = str(stack)
