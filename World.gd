extends Node2D

var player = load("res://scenes//Player.tscn")
var map: Object

func init_map(scene_name: String) -> void:
	var map_scene = load("res://scenes//" + scene_name + ".tscn")
	pass

func init_player(id):
	var player_instance = Global.init_node_at_location(
		player,
		self,
		Vector2(rand_range(0, 300), rand_range(0, 300))
	)
	
	player_instance.name = str(id)
	player_instance.set_network_master(id)

func _ready():
	pass # Replace with function body.
