class_name Target
extends RefCounted

var node : WeakRef

func target(node: Node) -> void:
    self.node = weakref(node)
    self.node.tree_exiting.connect(_on_exiting)

func has_target() -> bool:
    return self.node != null

func get_target() -> Node:
    return self.node.get_ref()

func _on_exiting():
    self.node.tree_exiting.disconnect(_on_exiting)
    self.node = null
