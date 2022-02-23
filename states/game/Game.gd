extends Node2D

var weapon_pistol = preload("res://weapons//weapons//Pistol.tscn")
var player = load("res://entities//Player.tscn")
var camera: Camera2D
var local_player: KinematicBody2D
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
	var pistol = weapon_pistol.instance()
	player_instance.attach_weapon(pistol)
	
	return player_instance

func remove_player(id: int) -> void:
	if players_container.has_node(str(id)):
		var player_instance = players_container.get_node(str(id))
		players_container.remove_child(player_instance)
		player_instance.queue_free()

func _control_camera_position(delta: float) -> void:
	var mouse_position = get_global_mouse_position()
	var target = local_player.global_position
	var mid_x = (target.x + mouse_position.x) / 2
	var mid_y = (target.y + mouse_position.y) / 2
	
	camera.global_position = camera.global_position.linear_interpolate(Vector2(mid_x, mid_y), delta * 5)

func _process(delta: float) -> void:
	_control_camera_position(delta)

func _ready():
	start()
	
	local_player = init_player(get_tree().get_network_unique_id())
	camera = Camera2D.new()
	camera._set_current(true)
	add_child(camera)
	#camera.set_enable_follow_smoothing(true)
	#local_player.add_child(camera)
	
	# Server
	get_tree().connect("network_peer_connected", self, "_player_connected")
	get_tree().connect("network_peer_disconnected", self, "_player_disconnected")
	
	# Client
	get_tree().connect("connected_to_server", self, "_connected_to_server")
	get_tree().connect("server_disconnected", self, "_server_disconnected")

func _notification(what) -> void:
	if what == NOTIFICATION_PREDELETE:
		pass

func _exit_tree():
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
