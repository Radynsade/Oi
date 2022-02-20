extends Control

onready var input_container = $InputContainer
onready var my_ip_address_label = $IpContainer/LocalIpLabel
onready var ip_input = $InputContainer/IpLineEdit
onready var port_input = $InputContainer/PortLineEdit

func _ready():	
	my_ip_address_label.text = "Local IP: " + str(Network.local_ip)

func _on_BackButton_pressed():
	MenuNavigation.load_menu(MenuNavigation.MENU_TYPE.MAIN)

func _on_ConnectButton_pressed():
	MenuNavigation.unload_menus()
	if ip_input.text != "":
		if port_input.text != "":
			Network.join_server(ip_input.text, int(port_input.text))
		else:
			Network.join_server(ip_input.text)

func _on_CreateServerButton_pressed():
	MenuNavigation.unload_menus()
	
	if port_input.text != "":
		Network.create_server_from_game(int(port_input.text))
	else:
		Network.create_server_from_game()
