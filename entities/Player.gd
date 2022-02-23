extends KinematicBody2D

signal network_master_changed

const DEFAULT_ABILITY_VALUE: int = 4
const MAX_ABILITY_VALUE: int = 8
const MIN_ABILITY_VALUE: int = 1

# Skin
var color: Color = Color(0.0, 0.9, 0.5, 1.0)

# Abilities
var ability_speed: int = 4
var ability_fov: int = 4
var ability_health: int = 4
var ability_power: int = 4

var speed = 350
var health = 100
var power = 10

# Technical
var debug_distance_of_view_color = Color(1, 1, 0, 0.1)
var velocity = Vector2.ZERO
var direction = Vector2.ZERO
var Weapon = preload("res://weapons//Weapon.gd")
puppet var puppet_position = Vector2(0, 0) setget puppet_position_set
puppet var puppet_rotation = 0
puppet var puppet_velocity = Vector2()
onready var tween = $Tween
onready var visual = $Visual
onready var vision = $Vision
onready var left_hand = $Visual/LeftHand
onready var right_hand = $Visual/RightHand
onready var body_sprite = $Visual/BodySprite
onready var shadow_sprite = $Visual/ShadowSprite

func process_input():
	velocity.x = int(Input.is_action_pressed("player_right")) - int(Input.is_action_pressed("player_left"))
	velocity.y = int(Input.is_action_pressed("player_down")) - int(Input.is_action_pressed("player_up"))
	velocity = velocity.normalized() * speed
	visual.velocity = velocity
	
	if Input.is_action_just_pressed("player_attack"):
		print("start attacking")
	
	if Input.is_action_just_released("player_attack"):
		print("stop attacking")

func process_fov():
	pass

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
	var angle_from = 90 - vision.field_of_view / 2
	var angle_to = 90 + vision.field_of_view / 2
	
	points.push_back(Vector2.ZERO)
	
	for i in range(division + 1):
		var point = deg2rad(angle_from + i * (angle_to - angle_from) / division - 90)
		points.push_back(Vector2(cos(point), sin(point)) * vision.distance)
	
	draw_polygon(points, PoolColorArray([debug_distance_of_view_color]))

func draw_view_rays():
	for hit in vision.hit_points:
		var relative_hit = (hit - global_position).rotated(-global_rotation)
		draw_line(Vector2.ZERO, relative_hit, Color.white)
		draw_circle(relative_hit, 5, Color.white)

func on_network_master_change() -> void:
	if is_network_master():
		vision.connect("object_detected", self, "_on_Vision_object_detected")
		vision.connect("object_left", self, "_on_Vision_object_left")
	else:
		if !vision.is_connected("object_detected", self, "_on_Vision_object_detected"):
			return
		
		if !vision.is_connected("object_left", self, "_on_Vision_object_left"):
			return
		
		vision.disconnect("object_detected", self, "_on_Vision_object_detected")
		vision.disconnect("object_left", self, "_on_Vision_object_left")
		hide()

func attach_weapon(node: Weapon) -> void:
	visual.add_child(node)
	left_hand.position = node.left_hand_position
	right_hand.position = node.right_hand_position
	node.position = node.weapon_position
	visual.move_child(node, 2)

func _short_angle_distance(from ,to):
	var max_angle = PI * 2
	var difference = fmod(to - from, max_angle)
	return fmod(2 * difference, max_angle) - difference

func _lerp_angle(from, to, weight):
	return from + _short_angle_distance(from, to) * weight

func _draw() -> void:
	if !Global.is_debug_on():
		return
	
	if !is_network_master():
		return
	
	draw_view_area()
	draw_view_rays()

func set_network_master(id: int, recursive: bool = true) -> void:
	.set_network_master(id, recursive)
	emit_signal("network_master_changed")

func _ready():
	body_sprite.material.set_shader_param("fillColor", color)
	Global.connect("debug_state_changed", self, "update")
	connect("network_master_changed", self, "on_network_master_change")

func _physics_process(delta):
	if is_network_master():
		process_input()
		process_fov()
		move_and_slide(velocity)
		update()

func _process(delta):
	if is_network_master():
		look_at(get_global_mouse_position())
	else:
		rotation = _lerp_angle(
			rotation,
			puppet_rotation,
			delta * 12
		)
		
		if not tween.is_active():
			move_and_slide(puppet_velocity)

func _on_NetworkTickRate_timeout():
	if is_network_master():
		rset_unreliable("puppet_position", global_position)
		rset_unreliable("puppet_rotation", rotation)
		rset_unreliable("puppet_velocity", velocity)

func _on_Vision_object_detected(object):
	object.show()

func _on_Vision_object_left(object):
	object.hide()
