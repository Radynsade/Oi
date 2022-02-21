extends Node

enum STATES {
	GAME,
	MENUS
}

signal debug_state_changed
signal game_state_changed(state)

var _states_scenes = {
	STATES.GAME: "res://states//game//Game.tscn",
	STATES.MENUS: "res://states//main//Main.tscn"
}

var _debug_on: bool = false

# DO NOT MUTATE THIS OUTSIDE THIS CLASS!
var _current_state: int = STATES.MENUS

func is_debug_on() -> bool:
	return _debug_on

func fatal_error(text: String) -> void:
	push_error(text)
	get_tree().quit()

func init_node(
	node: Object,
	parent: Object
) -> Object:
	var instance = node.instance()
	parent.add_child(instance)
	return instance

func init_node_at_location(
	node: Object,
	parent: Object,
	location: Vector2
) -> Object:
	var instance = init_node(node, parent)
	instance.global_position = location
	return instance

func clean_node(node: Node) -> void:
	for child in node.get_children():
		node.remove_child(child)
		child.queue_free()

func get_state() -> int:
	return _current_state

func set_state(state: int) -> void:
	match state:
		STATES.GAME:
			get_tree().change_scene(_states_scenes[STATES.GAME])
		STATES.MENUS:
			get_tree().change_scene(_states_scenes[STATES.MENUS])
	
	_current_state = state
	emit_signal("game_state_changed", state)

func is_game_state() -> bool:
	return _current_state == STATES.GAME

func _process(delta):
	if Input.is_action_just_pressed("debug_visibility"):
		_debug_on = !_debug_on
		emit_signal("debug_state_changed")
