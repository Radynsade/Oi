extends Node

const _PHYSICS_FPS = 60

func movement_jitter_fix(
	parent: Node,
	velocity: Vector2,
	delta,
	children_to_fix: Array
) -> void:
	var fps = Engine.get_frames_per_second()
	var lerp_interval = velocity / fps
	var lerp_position = parent.global_position + lerp_interval
	
	if fps > _PHYSICS_FPS:
		for child in children_to_fix:
			child.set_as_toplevel(true)
			child.global_rotation = parent.global_rotation
			child.global_position = child.global_position.linear_interpolate(lerp_position, 10 * delta)
	else:
		for child in children_to_fix:
			child.global_position = parent.global_position
			child.set_as_toplevel(false)
