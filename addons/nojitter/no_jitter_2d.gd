extends Node2D

var velocity: Vector2
onready var parent = get_parent()

func _ready():
	set_as_toplevel(true)

func _process(delta):
	var fps = Engine.get_frames_per_second()
	var lerp_interval = velocity / fps
	var lerp_position = parent.global_position + lerp_interval
	
	global_rotation = parent.global_rotation
	global_position = global_position.linear_interpolate(lerp_position, 10 * delta)
