extends Area2D

func collision(body: Node) -> void:
	if body.is_in_group("Entity"):
		body.get_node("HP").hit($".".get_meta("Damage"), $".".get_meta("instant_kill"))
