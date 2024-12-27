extends Node


func _on_child_entered_tree(node: Node) -> void:
	$".".set_meta("Loaded_Scene", node)
