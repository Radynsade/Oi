extends "res://weapons/Ranged.gd"

func _physics_process(delta) -> void:
	if !is_network_master():
		return
	
	if Input.is_action_just_pressed("player_attack"):
		print("start attacking")
	
	if Input.is_action_just_released("player_attack"):
		print("stop attacking")

