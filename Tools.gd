extends Node

func _enter_tree():
	add_custom_type("NoJitter2D", "Node2D", preload("no_jitter_2d.gd"), preload("no_jitter_2d.png"))
	pass

func _exit_tree():
	remove_custom_type("NoJitter2D")

func _ready():
	pass # Replace with function body.
