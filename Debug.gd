extends CanvasLayer

var fps: int = 0
onready var fps_label = $GUI/VBoxContainer/FpsLabel

func _process(delta):
	fps = Engine.get_frames_per_second()
	fps_label.text = "FPS: " + str(fps)
