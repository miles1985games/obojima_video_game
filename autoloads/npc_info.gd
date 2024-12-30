extends Node

var npc_roster = {
	"head_witch" = {
		"name" = "Head Witch",
		"scene" = load("res://npc/npc_head_witch.tscn"),
		"schedule" = {
			8: "home",
			12: "town",
			15: "head_witch_house_interior",
		},
		"interests" = {
			"storefront": 5,
		},
	},
	"cat" = {
		"name" = "Cat",
		"scene" = load("res://npc/npc_cat.tscn"),
		"schedule" = {
			8: "beach",
			16: "beach",
			18: "town",
		},
		"interests" = {
			"storefront": 5,
		},
	},
}

var quest_roster = {
	"0" = {
		"type" = "fetch_ingredient",
		"dialogue" = ["Hey! I need some ingredients.", "You think you could find this for me?"],
		"item_type" = "ingredient",
		"item" = "amber",
		"amount" = null,
		"reward_type" = "potion",
		"reward_subtype" = null,
		"reward" = null,
		"reward_dialogue" = ["Thanks so much!"],
	},
}
