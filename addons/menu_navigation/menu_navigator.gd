extends CanvasLayer

class_name MenuNavigator

func _hide_all() -> void:
	for child in get_children():
		child.hide()

func go_to_child(index: int) -> void:
	_hide_all()
	get_child(index).show()

func go_to_node(node_path: String) -> void:
	_hide_all()
	get_node(node_path).show()

func _ready() -> void:
	go_to_child(0)
