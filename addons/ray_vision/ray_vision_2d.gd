extends Node2D

signal object_detected(object)
signal object_left(object)

export var angle_between_rays: int
export var distance: float
export var field_of_view: float
var hit_points: PoolVector2Array = []
var current_seen_objects = []
var previous_seen_objects = []
var _space_state: Physics2DDirectSpaceState
onready var _parent = get_parent()
onready var _side_rays_amount = field_of_view / angle_between_rays / 2

func _register_result(result: Dictionary) -> void:
	hit_points.append(result.position)
	var collider = result.collider
	if collider.is_in_group("detectable") && not current_seen_objects[result.collider_id]:
		emit_signal("object_detected", collider)
		current_seen_objects[result.collider_id] = collider

func _cast_ray(angle: float) -> void:
	var direction = Vector2(cos(angle), sin(angle)).normalized() * distance + global_position
	var result = _space_state.intersect_ray(global_position, direction, [_parent], _parent.collision_mask)
	if result:
		_register_result(result)

func _physics_process(delta) -> void:
	_space_state = get_world_2d().direct_space_state
	

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
