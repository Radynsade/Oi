extends KinematicBody2D

const DEFAULT_ABILITY_VALUE: int = 4
const MAX_ABILITY_VALUE: int = 8
const MIN_ABILITY_VALUE: int = 1
const ANGLE_BETWEEN_RAYS: float = 3.0

# Skin
var color: Color = Color(0.0, 0.9, 0.5, 1.0)

# Abilities
var ability_speed: int = 4
var ability_fov: int = 4
var ability_health: int = 4
var ability_power: int = 4

var speed = 350
var distance_of_view = 350
var field_of_view = 120
var health = 100
var power = 10

# Technical
var debug_distance_of_view_color = Color(1, 1, 0, 0.3)
var velocity = Vector2.ZERO
var direction = Vector2.ZERO
puppet var puppet_position = Vector2(0, 0) setget puppet_position_set
puppet var puppet_rotation = 0
puppet var puppet_velocity = Vector2()
onready var tween = $Tween
onready var body_sprite = $BodySprite
onready var shadow_sprite = $ShadowSprite

func process_input():
	velocity.x = int(Input.is_action_pressed("player_right")) - int(Input.is_action_pressed("player_left"))
	velocity.y = int(Input.is_action_pressed("player_down")) - int(Input.is_action_pressed("player_up"))
	velocity = velocity.normalized() * speed

func process_fov():
	var direction = Vector2(cos(global_rotation), sin(global_rotation)).normalized()
	var straight = Vector2(1, 0)
	
	direction.rotated()
	# var dot_product: float
	
	# for node in get_tree().get_nodes_in_group("detectable"):
	# 	if global_position.distance_to(node.global_position) < distance_of_view:
	# 		dot_product = direction.dot()
	
	var space_state = get_world_2d().direct_space_state
	var result = space_state.intersect_ray(global_position, direction, [self])

func puppet_position_set(new_value: Vector2) -> void:
	puppet_position = new_value
	
	tween.interpolate_property(
		self,
		"global_position",
		global_position,
		puppet_position,
		0.1
	)
	
	tween.start()

func draw_view_area():
	var division = 32
	var points = PoolVector2Array()
	var angle_from = 90 - field_of_view / 2
	var angle_to = 90 + field_of_view / 2
	
	points.push_back(Vector2.ZERO)
	
	for i in range(division + 1):
		var point = deg2rad(angle_from + i * (angle_to - angle_from) / division - 90)
		points.push_back(Vector2(cos(point), sin(point)) * distance_of_view)
	
	draw_polygon(points, PoolColorArray([debug_distance_of_view_color]))

func draw_view_rays():
	var side_rays_amount = field_of_view / ANGLE_BETWEEN_RAYS / 2
	
	for i in range(side_rays_amount):
		var angle = deg2rad(i * ANGLE_BETWEEN_RAYS)
		
		draw_line(Vector2.ZERO, Vector2(cos(angle), sin(angle)) * distance_of_view, Color.white)
		draw_line(Vector2.ZERO, Vector2(cos(-angle), sin(-angle)) * distance_of_view, Color.white)
	
	draw_line(Vector2.ZERO, Vector2(distance_of_view, 0), Color.white)

func _draw() -> void:
	if !Global.is_debug_on():
		return
	
	draw_view_area()
	draw_view_rays()

func _ready():
	var bodySprite = get_node("BodySprite")
	bodySprite.material.set_shader_param("fillColor", color)
	
	Global.connect("debug_state_changed", self, "update")

func _physics_process(delta):
	if is_network_master():
		update()
		process_input()
		# process_fov()
		move_and_slide(velocity)

func _process(delta):
	Render.movement_jitter_fix(
		self,
		velocity,
		delta,
		[body_sprite, shadow_sprite]
	)
	
	if is_network_master():
		look_at(get_global_mouse_position())
	else:
		rotation = lerp(
			rotation,
			puppet_rotation,
			delta * 2
		)
		
		if not tween.is_active():
			move_and_slide(puppet_velocity)

func _on_NetworkTickRate_timeout():
	if is_network_master():
		rset_unreliable("puppet_position", global_position)
		rset_unreliable("puppet_rotation", rotation)
		rset_unreliable("puppet_velocity", velocity)

func _on_ViewDistanceArea_body_entered(body):
	pass # Replace with function body.

func _on_ViewDistanceArea_body_exited(body):
	pass # Replace with function body.
