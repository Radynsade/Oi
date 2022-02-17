extends Control

func _on_SettingsButton_pressed():
	pass # Replace with function body.

func _on_QuitButton_pressed():
	get_tree().quit()

func _on_MultiplayerButton_pressed():
	MenuNavigation.load_menu(MenuNavigation.MENU_TYPE.NETWORK)
	pass # Replace with function body.
