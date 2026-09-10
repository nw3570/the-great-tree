extends Node

func scene_instance(scene_path: String) -> Node:
	var s = load(scene_path) as PackedScene
	return s.instantiate()

func switch_scene_to_file(target: Node, new_scene_path: String) -> void:
	var new_scene = scene_instance(new_scene_path)
	_deferred_switch_nodes.call_deferred(target, new_scene)

func switch_scene_to_node(from: Node, to: Node) -> void:
	_deferred_switch_nodes.call_deferred(from, to)

func _deferred_switch_nodes(from: Node, to: Node) -> void:
	var parent = from.get_parent()
	var index = from.get_index()
	
	parent.remove_child(from)
	from.queue_free()
	
	parent.add_child(to)
	parent.move_child(to, index)
