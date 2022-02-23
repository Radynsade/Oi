extends Node2D

var velocity = Vector2(1, 0)
var speed = 1000
var damage = 25
var player_rotation

puppet var puppet_position setget puppet_position_set
puppet var puppet_velocity = Vector2.ZERO
puppet var puppet_rotation = 0

onready var initial_position = global_position

func puppet_position_set(new) -> void:
	puppet_position = new
	global_position = puppet_position

func _ready():
	visible = false
	yield(get_tree(), "idle_frame")
	
	if is_network_master():
		velocity = velocity.rotated(player_rotation)
		rset("puppet_velocity", velocity)
		rset("puppet_rotation", rotation)
		rset("puppet_position", global_position)
	
	visible = true

func _physics_process(delta):
	if is_network_master():
		global_position += velocity * speed * delta
	else:
		rotation = puppet_rotation
		global_position += puppet_velocity * speed * delta

sync func destroy() -> void:
	queue_free()

func _on_DestroyTimer_timeout():
	if get_tree().is_network_server():
		rpc("destroy")
