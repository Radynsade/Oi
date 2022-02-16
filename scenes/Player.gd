extends KinematicBody2D

var color = Color(0.0, 0.9, 0.5, 1.0)
var speed = 7
var velocity = Vector2.ZERO

func process_input():
	if Input.is_action_pressed("player_up"):
		velocity.y = -1
	elif Input.is_action_pressed("player_down"):
		velocity.y = 1
	else:
		velocity.y = 0
	
	if Input.is_action_pressed("player_left"):
		velocity.x = -1
	elif Input.is_action_pressed("player_right"):
		velocity.x = 1
	else:
		velocity.x = 0
	
	velocity = velocity.normalized() * speed

func _ready():
	var bodySprite = get_node("BodySprite")
	bodySprite.material.set_shader_param("fillColor", color)
	
func _physics_process(delta):
	process_input()
	move_and_collide(velocity)
	look_at(get_global_mouse_position())
