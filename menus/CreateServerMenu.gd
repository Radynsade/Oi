extends Control

onready var my_ip_address_label = $VBoxContainer/MyIPLabel

# Called when the node enters the scene tree for the first time.
func _ready():
	# get_tree().connect("network_peer_connected", self, "_player_connected")
	# get_tree().connect("network_peer_disconnected", self, "_player_disconnected")
	# get_tree().connect("connected_to_server", self, "_connected_to_server")
	
	my_ip_address_label.text = Network.ipAddress

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
