extends Node

var player = load("res://entities//Player.tscn")
onready var map_container = $Map
onready var players_container = $Players

func set_map(name: String) -> void:
	Global.clean_node(map_container)
	var map = load("res://maps//" + name + ".tscn").instance()
	map_container.add_child(map)

func start() -> void:
	set_map("Garden")

func init_player(id: int) -> void:
	var player_instance = Global.init_node_at_location(
		player,
		players_container,
		Vector2(rand_range(0, 300), rand_range(0, 300))
	)
	
	player_instance.name = str(id)
	player_instance.set_network_master(id)

func remove_player(id: int) -> void:
	if players_container.has_node(str(id)):
		get_node(str(id)).queue_free()

func _ready():
	# Server
	get_tree().connect("network_peer_connected", self, "_player_connected")
	get_tree().connect("network_peer_disconnected", self, "_player_disconnected")
	
	# Client
	get_tree().connect("connected_to_server", self, "_connected_to_server")
	get_tree().connect("server_disconnected", self, "_server_disconnected")
	
	start()
	init_player(get_tree().get_network_unique_id())

# Server

func _player_connected(id) -> void:
	print("Player " + str(id) + " has connected")
	init_player(id)

func _player_disconnected(id) -> void:
	print("Player " + str(id) + " has disconnected")
	remove_player(id)

# Client

func _connected_to_server() -> void:
	yield(get_tree().create_timer(0.1), "timeout")
	print("Successfuly connected to the server")

func _server_disconnected() -> void:
	Global.set_state(Global.STATES.MENUS)
	print("Disconnected from the server")
