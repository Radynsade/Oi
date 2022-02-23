extends Node2D

const _PHYSICS_FPS = 60

var velocity: Vector2
var fix: bool = false
onready var parent = get_parent()

func _ready():
	if parent.is_network_master():
		fix = true
		set_as_toplevel(true)

func _physics_process(delta):
	if fix:
		visible = parent.visible

func _process(delta):
	if !fix:
		return
	
	var fps = Engine.get_frames_per_second()
	var lerp_interval = velocity / fps
	var lerp_position = parent.global_position + lerp_interval
	global_rotation = parent.global_rotation
	
	if fps > _PHYSICS_FPS:
		global_position = global_position.linear_interpolate(lerp_position, 10 * delta)
	else:
		global_position = parent.global_position
