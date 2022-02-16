extends Control

onready var my_ip_address_label = $IpContainer/LocalIpLabel

func _ready():
	get_tree().connect("network_peer_connected", self, "_player_connected")
	get_tree().connect("network_peer_disconnected", self, "_player_disconnected")
	get_tree().connect("connected_to_server", self, "_connected_to_server")
	
	my_ip_address_label.text = "Local IP: " + str(Network.local_ip)

func _on_BackButton_pressed():
	MenuNavigation.load_menu(MenuNavigation.MENU_TYPE.MAIN)

func _on_ConnectButton_pressed():
	MenuNavigation.load_menu(MenuNavigation.MENU_TYPE.CONNECT_SERVER)

func _on_CreateServerButton_pressed():
	MenuNavigation.load_menu(MenuNavigation.MENU_TYPE.CREATE_SERVER)
