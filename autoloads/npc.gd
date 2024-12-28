extends Node

var npc_roster = {
	"head_witch" = {
		"name" = "Head Witch",
		"scene" = preload("res://npc/npc_head_witch.tscn"),
		"schedule" = {
			8: "town",
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
