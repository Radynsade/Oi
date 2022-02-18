extends Node2D

signal object_detected(object)
signal object_left(object)

export var angle_between_rays: int
export var distance: float
export var field_of_view: float
var hit_points: PoolVector2Array = []
var current_detected_objects = {}
var previous_detected_objects = {}
var _space_state: Physics2DDirectSpaceState
onready var _parent = get_parent()
onready var _side_rays_amount = field_of_view / angle_between_rays / 2

func _register_result(result: Dictionary) -> void:
	hit_points.append(result.position)
	var collider = result.collider
	if collider.is_in_group("detectable") && not current_detected_objects[result.collider_id]:
		emit_signal("object_detected", collider)
		current_detected_objects[result.collider_id] = collider

func _cast_ray(angle: float) -> void:
	var direction = Vector2(cos(global_rotation + angle), sin(global_rotation + angle)).normalized() * distance + global_position
	var result = _space_state.intersect_ray(global_position, direction, [_parent], _parent.collision_mask)
	if result:
		_register_result(result)

func _update_detected_objects() -> void:
	var detected: bool
	
	for previous_id in previous_detected_objects.keys():
		var object = previous_detected_objects[previous_id]
		
		if not object && object == null:
			return
		
		detected = false
		
		for current_id in current_detected_objects.keys():
			if current_id == previous_id:
				detected = true
				break
		
		if !detected:
			emit_signal("object_left", object)

func _physics_process(delta) -> void:
	current_detected_objects = {}
	hit_points = []
	_space_state = get_world_2d().direct_space_state
	_cast_ray(0)
	
	var angle: float
	
	for i in range(_side_rays_amount + 1):
		angle = deg2rad(i * angle_between_rays)
		_cast_ray(angle)
		_cast_ray(-angle)
	
	_update_detected_objects()
	previous_detected_objects = current_detected_objects
