extends Node2D

export var left_hand_position: Vector2
export var left_hand_top: bool
export var right_hand_position: Vector2
export var right_hand_top: bool
# There are 3 types: melee, range, grenade
export var type: String

# Range options
export var is_automatic: bool
export var time_between_shots: bool

func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
