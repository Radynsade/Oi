extends CanvasLayer

var fps: int = 0
onready var gui = $GUI
onready var fps_label = $GUI/VBoxContainer/FpsLabel

func update_stats() -> void:
	fps = Engine.get_frames_per_second()
	fps_label.text = "FPS: " + str(fps)

func _process(delta):
	if gui.visible:
		update_stats()
	
	if Input.is_action_just_pressed("debug_visibility"):
		if gui.visible:
			gui.hide()
		else:
			gui.show()

func _ready() -> void:
	gui.hide()
