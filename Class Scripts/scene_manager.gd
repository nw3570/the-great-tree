extends Node

## Emitted when a deferred scenes/nodes switch has completed.
signal switch_completed

## Loads and instantiates a node for the given scene_path.
func scene_instance(scene_path: String) -> Node:
	var s = load(scene_path) as PackedScene
	assert(s != null, "Scene at path '%s' could not be loaded." % scene_path)
	
	return s.instantiate()

## Loads the scene at new_scene_path and replaces old_scene with the instance.
##
## The actual operation is deferred to avoid changing the tree during
## mid-processing. The signal switch_completed is emitted when the operation is
## done.
func switch_scene_to_file(old_scene: Node, new_scene_path: String) -> void:
	var new_scene := scene_instance(new_scene_path)
	switch_scene_to_node(old_scene, new_scene)

## Replaces old_scene node with new_scene node in the tree structure.
##
## The actual operation is deferred to avoid changing the tree during
## mid-processing. The signal switch_completed is emitted when the operation is
## done.
func switch_scene_to_node(old_scene: Node, new_scene: Node) -> void:
	_deferred_switch_nodes.call_deferred(old_scene, new_scene)

## Does the actual switch between nodes, preserving old_scene node's position in
## the tree.
func _deferred_switch_nodes(old_scene: Node, new_scene: Node) -> void:
	var parent = old_scene.get_parent()
	var index = old_scene.get_index()
	
	parent.remove_child(old_scene)
	old_scene.queue_free()
	
	parent.add_child(new_scene)
	parent.move_child(new_scene, index)
	
	switch_completed.emit()

