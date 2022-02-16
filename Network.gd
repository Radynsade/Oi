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

func join_server(
	ip: String,
	port: int = DEFAULT_PORT
) -> void:
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
		if ip.begins_with("192.168."):
			local_ip = ip
			break
			
	# Server
	get_tree().connect("network_peer_connected", self, "_player_connected")
	get_tree().connect("network_peer_disconnected", self, "_player_disconnected")
	
	# Client
	get_tree().connect("connected_to_server", self, "_connected_to_server")
	get_tree().connect("server_disconnected", self, "_server_disconnected")
	get_tree().connect("connection_failed", self, "_connection_failed")

# Server

func _player_connected(id) -> void:
	print("Player " + str(id) + " has connected")
	
func _player_disconnected(id) -> void:
	print("Player " + str(id) + " has disconnected")

# Client

func _connected_to_server() -> void:
	print("Successfuly connected to the server")
	
func _server_disconnected() -> void:
	print("Disconnected from the server")
	
func _connection_failed() -> void:
	print("Connection failed")
