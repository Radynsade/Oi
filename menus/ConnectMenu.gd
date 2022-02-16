extends Control

func _on_BackButton_pressed():
	MenuNavigation.load_menu(MenuNavigation.MENU_TYPE.NETWORK)
