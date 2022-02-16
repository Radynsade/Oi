extends Node

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
