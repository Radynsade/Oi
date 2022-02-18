extends Node

var player = load("res://entities//Player.tscn")
var camera: Camera2D
onready var map_container = $Map
onready var players_container = $Players

func set_map(name: String) -> void:
	Global.clean_node(map_container)
	var map = load("res://maps//" + name + ".tscn").instance()
	map_container.add_child(map)

func start() -> void:
	set_map("Garden")

func init_player(id: int) -> KinematicBody2D:
	var player_instance = Global.init_node_at_location(
		player,
		players_container,
		Vector2(rand_range(0, 300), rand_range(0, 300))
	)
	
	player_instance.name = str(id)
	player_instance.set_network_master(id)
	
	return player_instance

func remove_player(id: int) -> void:
	if players_container.has_node(str(id)):
		var player_instance = players_container.get_node(str(id))
		players_container.remove_child(player_instance)
		player_instance.queue_free()

func _ready():
	start()
	
	var local_player = init_player(get_tree().get_network_unique_id())
	var camera = Camera2D.new()
	camera._set_current(true)
	camera.set_enable_follow_smoothing(true)
	local_player.add_child(camera)
	
	# Server
	get_tree().connect("network_peer_connected", self, "_player_connected")
	get_tree().connect("network_peer_disconnected", self, "_player_disconnected")
	
	# Client
	get_tree().connect("connected_to_server", self, "_connected_to_server")
	get_tree().connect("server_disconnected", self, "_server_disconnected")

func _notification(what) -> void:
	if what == NOTIFICATION_PREDELETE:
		# Server
		get_tree().disconnect("network_peer_connected", self, "_player_connected")
		get_tree().disconnect("network_peer_disconnected", self, "_player_disconnected")
		
		# Client
		get_tree().disconnect("connected_to_server", self, "_connected_to_server")
		get_tree().disconnect("server_disconnected", self, "_server_disconnected")

# Server

func _player_connected(id) -> void:
	print("Player " + str(id) + " has connected")
	var player = init_player(id)

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
