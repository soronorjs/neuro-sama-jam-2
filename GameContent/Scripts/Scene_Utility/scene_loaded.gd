extends Node

func _ready() -> void:
	SceneController.main_animation.stop()
	SceneController.main_animation.play("TransitionScreen")
	$".".set_meta("Loaded_Cooldown", true)
	await wait(0.5)
	$".".set_meta("Loaded_Cooldown", false)
	


func wait(seconds):
	await get_tree().create_timer(seconds).timeout


func _on_tree_entered() -> void:
	SceneController.main_animation.stop()
	SceneController.main_animation.play("TransitionScreen")
	$".".set_meta("Loaded_Cooldown", true)
	await wait(0.5)
	$".".set_meta("Loaded_Cooldown", false)
