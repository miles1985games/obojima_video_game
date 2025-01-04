extends Button

var type: String
var subtype: String
var item: String
var stack: float = 1.0

func populate():
	match type:
		"ingredient":
			icon = Ingredients.ingredients_roster[item]["icon"]
		"potion":
			icon = Potions.potions_roster[subtype][item]["icon"]
		"decor":
			icon = Decor.decor_roster[item]["front_sprite"]
	text = str(stack)
