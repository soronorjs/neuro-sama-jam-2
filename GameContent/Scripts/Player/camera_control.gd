extends Camera2D

@onready var Player = $"../.."
@onready var Scene = Player.get_parent()
@onready var CameraBounds = Scene.get_node("CameraBounds")

func _ready() -> void:
	self.make_current()
	if CameraBounds:
		self.limit_right = CameraBounds.get_node("BoundRight").position.x
		self.limit_left = CameraBounds.get_node("BoundLeft").position.x
		if CameraBounds.get_node("BoundTop"):
			self.limit_top = CameraBounds.get_node("BoundTop").position.y
			self.limit_bottom = CameraBounds.get_node("BoundBottom").position.y

func _physics_process(delta: float) -> void:
	$".".position = $"../../PlayerSprite".global_position
	
	
func wait(seconds):
	await get_tree().create_timer(seconds).timeout
