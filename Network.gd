extends Node

const DEFAULT_PORT = 28960
const MAX_CLIENTS = 32

var server = null
var client = null
var local_ip = ""
var player = load("res://scenes//Player.tscn")

func create_server(port: int = DEFAULT_PORT) -> void:
	server = NetworkedMultiplayerENet.new()
	server.create_server(port, MAX_CLIENTS)
	get_tree().set_network_peer(server)

func create_server_from_game(port: int = DEFAULT_PORT) -> void:
	Network.init_player(get_tree().get_network_unique_id())

func join_server(
	ip: String,
	port: int = DEFAULT_PORT
) -> void:
	client = NetworkedMultiplayerENet.new()
	client.create_client(ip, port)
	get_tree().set_network_peer(client)

func init_player(id) -> void:
	var player_instance = Global.init_node_at_location(
		player,
		Game,
		Vector2(rand_range(0, 300), rand_range(0, 300))
	)
	
	player_instance.name = str(id)
	player_instance.set_network_master(id)

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
	init_player(id)

func _player_disconnected(id) -> void:
	print("Player " + str(id) + " has disconnected")
	
	if Game.has_node(str(id)):
		Game.get_node(str(id)).queue_free()

# Client

func _connected_to_server() -> void:
	yield(get_tree().create_timer(0.1), "timeout")
	init_player(get_tree().get_network_unique_id())
	print("Successfuly connected to the server")

func _server_disconnected() -> void:
	print("Disconnected from the server")

func _connection_failed() -> void:
	print("Connection failed")
