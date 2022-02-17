extends Node2D

const _MAP_CONTAINER_NAME = "Map"
const _PLAYERS_CONTAINER_NAME = "Players"

var _player = load("res://scenes//Player.tscn")
var _map_container: Node2D
var _players_container: Node2D

func init_world() -> void:
	if !Global.is_game_state():
		Global.fatal_error("Cannot init world not at the GAME state.")
	
	var game_scene = get_tree().current_scene
	_map_container = game_scene.find_node(_MAP_CONTAINER_NAME, false, false)
	_players_container = game_scene.find_node(_PLAYERS_CONTAINER_NAME, false, false)

func init_map(scene_name: String) -> void:
	if !Global.is_game_state():
		Global.fatal_error("Cannot init map not at the GAME state.")
	
	if not _map_container:
		Global.fatal_error("Cannot init map without the map container! The world might be not initialized.")
	
	Global.clean_node(_map_container)
	
	var map_instance = load("res://maps//" + scene_name + ".tscn").instance()
	_map_container.add_child(map_instance)

func init_player(id):
	if !Global.is_game_state():
		Global.fatal_error("Cannot init player not at the GAME state.")
	
	if not _players_container:
		Global.fatal_error("Cannot init player without the players container! The world might be not initialized.")
	
	Global.clean_node(_players_container)
	
	var player_instance = Global.init_node_at_location(
		_player,
		_map_container,
		Vector2(rand_range(0, 300), rand_range(0, 300))
	)
	
	player_instance.name = str(id)
	player_instance.set_network_master(id)

func _ready():
	pass # Replace with function body.
