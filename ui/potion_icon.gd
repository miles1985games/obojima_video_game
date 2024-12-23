extends Button

var type
var id

func populate():
	icon = Potions.potions_roster[type][id]["icon"]
	if Potions.potions_roster[type][id]["discovered"] == false:
		set_colors_black()

func set_colors_black():
	add_theme_color_override("icon_normal_color", Color.BLACK)
	add_theme_color_override("icon_focus_color", Color.BLACK)
	add_theme_color_override("icon_pressed_color", Color.BLACK)
	add_theme_color_override("icon_hover_color", Color.BLACK)
	add_theme_color_override("icon_hover_pressed_color", Color.BLACK)
	add_theme_color_override("icon_disabled_color", Color.BLACK)
