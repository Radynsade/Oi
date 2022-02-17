extends KinematicBody2D

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
var field_of_view = 75
var health = 100
var power = 10

# Technical
var velocity = Vector2.ZERO
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

func _ready():
	var bodySprite = get_node("BodySprite")
	bodySprite.material.set_shader_param("fillColor", color)

func _physics_process(delta):
	if is_network_master():
		process_input()
		move_and_slide(velocity)

func _process(delta):
	# var fps = Engine.get_frames_per_second()
	# var lerp_interval = velocity / fps
	# var lerp_position = global_position + lerp_interval
	
	# if fps > 60:
	# 	body_sprite.set_as_toplevel(true)
	# 	shadow_sprite.set_as_toplevel(true)
	# 	body_sprite.global_rotation = global_rotation
	# 	body_sprite.global_position = body_sprite.global_position.linear_interpolate(lerp_position, 10 * delta)
	# 	shadow_sprite.global_rotation = global_rotation
	# 	shadow_sprite.global_position = shadow_sprite.global_position.linear_interpolate(lerp_position, 10 * delta)
	# else:
	#	body_sprite.global_position = global_position
	#	body_sprite.set_as_toplevel(false)
	#	shadow_sprite.global_position = global_position
	#	shadow_sprite.set_as_toplevel(false)
	
	Render.movement_jitter_fix(self, velocity, delta, [body_sprite, shadow_sprite])
	
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
