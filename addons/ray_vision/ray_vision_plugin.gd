tool
extends EditorPlugin

func _enter_tree():
	add_custom_type("RayVision2D", "Node2D", preload("ray_vision_2d.gd"), preload("ray_vision_2d.png"))
	pass

func _exit_tree():
	remove_custom_type("RayVision2D")
