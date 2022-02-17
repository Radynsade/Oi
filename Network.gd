extends Node

const DEFAULT_PORT = 28960
const MAX_CLIENTS = 32

var server = null
var client = null
var local_ip = ""

func create_server(port: int = DEFAULT_PORT) -> void:
	server = NetworkedMultiplayerENet.new()
	server.create_server(port, MAX_CLIENTS)
	get_tree().set_network_peer(server)

func create_server_from_game(port: int = DEFAULT_PORT) -> void:
	create_server(port)
	Global.set_state(Global.STATES.GAME)

func join_server(
	ip: String,
	port: int = DEFAULT_PORT
) -> void:
	Global.set_state(Global.STATES.GAME)
	client = NetworkedMultiplayerENet.new()
	client.create_client(ip, port)
	get_tree().set_network_peer(client)

func _ready() -> void:
	if OS.get_name() == "Windows":
		local_ip = IP.get_local_addresses()[3]
	elif OS.get_name() == "Android":
		local_ip = IP.get_local_addresses()[0]
	else:
		local_ip = IP.get_local_addresses()[3]

	for ip in IP.get_local_addresses():
		if ip.begins_with("192.168.") and not ip.ends_with(".1"):
			local_ip = ip
			break

	get_tree().connect("connection_failed", self, "_connection_failed")

func _connection_failed() -> void:
	print("Connection failed")
