extends KinematicBody2D

var color = Color(0.0, 0.9, 0.5, 1.0)
var speed = 7
var velocity = Vector2.ZERO
puppet var puppet_position = Vector2(0, 0) setget puppet_position_set
puppet var puppet_rotation = 0
puppet var puppet_velocity = Vector2()
onready var tween = $Tween

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

func _process(delta):
	if is_network_master():
		process_input()
		move_and_collide(velocity)
		look_at(get_global_mouse_position())
	else:
		rotation = lerp(
			rotation,
			puppet_rotation,
			delta * 4
		)
		
		if not tween.is_active():
			move_and_collide(puppet_velocity)

func _on_NetworkTickRate_timeout():
	if is_network_master():
		rset_unreliable("puppet_position", global_position)
		rset_unreliable("puppet_rotation", rotation)
		rset_unreliable("puppet_velocity", velocity)
