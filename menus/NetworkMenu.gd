extends Control

func _on_BackButton_pressed():
	MenuNavigation.load_menu(MenuNavigation.MENU_TYPE.MAIN)

func _on_ConnectButton_pressed():
	MenuNavigation.load_menu(MenuNavigation.MENU_TYPE.CONNECT_SERVER)
