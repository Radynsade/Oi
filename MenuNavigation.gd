extends Node

const MENU_NODE_NAME = "menu"

enum MENU_TYPE {
	NONE,
	MAIN,
	SETTINGS,
	NETWORK,
	CREATE_SERVER,
	CONNECT_SERVER
}

var menus = {
	MENU_TYPE.MAIN: preload("res://scenes//MainMenu.tscn").instance(),
	MENU_TYPE.CONNECT_SERVER: preload("res://scenes//ConnectMenu.tscn").instance(),
	MENU_TYPE.NETWORK: preload("res://scenes//NetworkMenu.tscn").instance(),
}

var currentMenu : Node = null

func load_menu(menuType) -> void:
	call_deferred("_deferred_load_menu", menuType)
	
func _deferred_load_menu(menuType) -> void:
	currentMenu = menus[menuType]
	var currentScene = get_tree().current_scene;
	var container = currentScene.find_node(MENU_NODE_NAME, false, false)
	
	if not container:
		var menuNode = Node.new()
		menuNode.set_name(MENU_NODE_NAME)
		currentScene.add_child(menuNode)
		container = menuNode
		
	for child in container.get_children():
		container.remove_child(child)
		
	container.add_child(currentMenu)
