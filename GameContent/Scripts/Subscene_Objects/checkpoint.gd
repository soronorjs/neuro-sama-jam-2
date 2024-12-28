extends Area2D




func _on_body_entered(body: Node2D) -> void:
	print("Works!")
	if body.has_meta("Checkpoint"):
		print("Works!")
		body.set_meta("Checkpoint", $".")
