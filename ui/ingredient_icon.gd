extends Button

var ingredient

func populate():
	icon = Ingredients.ingredients_roster[ingredient]["icon"]
	if Ingredients.ingredients_roster[ingredient]["discovered"] == false:
		set_colors_black()

func set_colors_black():
	add_theme_color_override("icon_normal_color", Color.BLACK)
	add_theme_color_override("icon_focus_color", Color.BLACK)
	add_theme_color_override("icon_pressed_color", Color.BLACK)
	add_theme_color_override("icon_hover_color", Color.BLACK)
	add_theme_color_override("icon_hover_pressed_color", Color.BLACK)
	add_theme_color_override("icon_disabled_color", Color.BLACK)
