extends CanvasLayer

var fps: int = 0
var shown: bool = false
onready var gui = $GUI
onready var fps_label = $GUI/VBoxContainer/FpsLabel

func update_stats() -> void:
	fps = Engine.get_frames_per_second()
	fps_label.text = "FPS: " + str(fps)

func _process(delta):
	if shown:
		update_stats()
	
	if Input.is_action_just_pressed("debug_visibility"):
		if shown:
			gui.hide()
			shown = false
		else:
			gui.show()
			shown = true

func _ready() -> void:
	gui.hide()
