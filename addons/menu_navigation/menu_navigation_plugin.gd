tool
extends EditorPlugin

func _enter_tree():
	add_custom_type("MenuNavigator", "CanvasLayer", preload("menu_navigator.gd"), preload("menu_navigator.png"))

func _exit_tree():
	remove_custom_type("MenuNavigator")
