extends Node

var ingredients_roster: Dictionary = {
	"amber" = {
		"name" = "Amber",
		"icon" = preload("res://assets/ingredients/amber.png"),
		"combat" = 9,
		"utility" = 5,
		"whimsy" = 4,
		"description" = "This chunk of petrified tree sap is prized for its color and gem-like luster and is often used in jewelry. Somearcane jewelers claim that it has special properties, especially if an ancient insect is trapped within it. Amber can be found in rocky areas where petrifi ed wood is found, and it has been known to wash up on certain beaches.",
		"discovered" = true,
		"stats_discovered" = true,
	},
	"apper_carrot" = {
		"name" = "Apper Carrot",
		"icon" = preload("res://assets/ingredients/apper_carrot.png"),
		"combat" = 0,
		"utility" = 3,
		"whimsy" = 1,
		"description" = "The Apper Carrot is well known throughout Obojima as a superior strain of carrot that has a delicious flavor and a hearty crunch. Its bulbous top peeks out from the soil when it’s ready for harvesting, making it easy for foragers to spot Apper Carrots in the wild. They can be found in most grassy lowland areas.",
		"discovered" = false,
		"stats_discovered" = false,
	},
	"bamboo" = {
		"name" = "Bamboo",
		"icon" = preload("res://assets/ingredients/bamboo.png"),
		"combat" = 3,
		"utility" = 3,
		"whimsy" = 3,
		"description" = "Used in everything from building material to drinking vessels and musical instruments, bamboo is perhaps the most versatile material on the island. Patches of bamboo can be found in most places on Obojima, however there are a few bamboo forests in the foothills and mountainous regions where it can grow as thick as a tree.",
		"discovered" = true,
		"stats_discovered" = false,
	},
}
