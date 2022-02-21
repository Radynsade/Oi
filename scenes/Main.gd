extends MenuNavigator

onready var my_ip_address_label = $NetworkMenu/IpContainer/LocalIpLabel
onready var ip_input = $NetworkMenu/InputContainer/IpLineEdit
onready var port_input = $NetworkMenu/InputContainer/PortLineEdit

func _ready():
	my_ip_address_label.text = "Local IP: " + str(Network.local_ip)

func _on_MultiplayerButton_pressed():
	go_to_node("NetworkMenu")

func _on_QuitButton_pressed():
	get_tree().quit()

func _on_ConnectButton_pressed():
	if ip_input.text != "":
		if port_input.text != "":
			Network.join_server(ip_input.text, int(port_input.text))
		else:
			Network.join_server(ip_input.text)

func _on_CreateServerButton_pressed():
	if port_input.text != "":
		Network.create_server_from_game(int(port_input.text))
	else:
		Network.create_server_from_game()

func _on_BackButton_pressed():
	go_to_node("MainMenu")
