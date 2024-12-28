extends Node2D

var known_recipes = {
	"combat" = {},
	"utility" = {},
	"whimsy" = {},
}

#var temp_array: Array

func _ready() -> void:
	World.recipe_handler = self

func save_recipe(potion_type, potion_id, potion_name, ingredients_array):
	print("initial ing: " + str(ingredients_array))
	#temp_array.clear()
	#for i in ingredients_array:
		#temp_array.append(i)
	ingredients_array.sort_custom(func(a,b): return a < b)
	#print("temp array: " + str(temp_array))
	var recipe_known: bool = false
	
	for t in known_recipes:
		for i in known_recipes[t]:
			for n in known_recipes[t][i]:
				if known_recipes[t][i][n] == ingredients_array:
					recipe_known = true
					print("found recipe: " + str(known_recipes[t][i][n]) + " ing array: " + str(ingredients_array))
					break
	if recipe_known:
		print("recipe known")
	else:
		if known_recipes[potion_type].keys().has(potion_id):
			print("recipe unknown")
			var size = known_recipes[potion_type][potion_id].keys().size()
			known_recipes[potion_type][potion_id][size] = ingredients_array
		else:
			print("potion unknown")
			known_recipes[potion_type][potion_id] = {}
			known_recipes[potion_type][potion_id]["0"] = ingredients_array
	print(known_recipes)
