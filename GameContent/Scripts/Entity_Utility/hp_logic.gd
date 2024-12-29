extends Node

@onready var Player = $".."
@onready var HP = Player.get_meta("HP")
@onready var original_HP = Player.get_meta("HP")

func _physics_process(delta):
	HP = Player.get_meta("HP")
	if HP <= 0:
		respawn_last_checkpoint()
		Player.set_meta("HP", original_HP)

func hit(damage, instant):
	if not instant:
		Player.set_meta("HP", Player.get_meta("HP") - damage)
	else:
		respawn_last_checkpoint()
		Player.set_meta("HP", Player.get_meta("HP") - 1)
		
func respawn_last_checkpoint():
	var Checkpoint = Player.get_meta("Checkpoint")
	if Checkpoint:
		Player.position = Checkpoint.global_position
	else:
		Player.position = Vector2(0, 0)
