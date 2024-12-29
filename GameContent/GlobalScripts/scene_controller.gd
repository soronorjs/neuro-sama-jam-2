extends Node2D

@onready var scene_holder = get_node("/root/MainScene/SceneHolder")
@onready var main_audio = get_node("/root/MainScene/MainAudio")
@onready var main_volume_db = AudioServer.get_bus_volume_db(AudioServer.get_bus_index("Master"))
@onready var main_animation = MainScene.get_node("MainAnimation")

@onready var tweenSound = get_tree().create_tween()

@export var went_back = false

var scene

func _ready():
	MainScene.get_node("CanvasLayer/Transition").visible = true
	main_audio.volume_db = 0.0
	load_scene("res://GameContent/Scenes/Levels/test.tscn")

func load_scene(scene_path: String):
	if not MainScene.get_node("CanvasLayer/Transition").color == Color.BLACK and not scene_path == "res://GameContent/Scenes/UI/main_menu.tscn":
		main_animation.play_backwards("TransitionScreen") 
	
	if scene_path == "res://GameContent/Scenes/UI/main_menu.tscn":
		var volume = main_audio.volume_db
		tweenSound.stop()
		main_audio.play(0.0)
		tweenSound.tween_method(Callable(self, "set_bus_volume_db"), volume, 0.0, 3)
		tweenSound.play()
	else:
		tweenSound.stop()
	
	while main_animation.is_playing() and main_animation.current_animation == "TransitionScreen" and main_animation.get_playing_speed() == -1.0:
		await get_tree().process_frame
		
	scene = null

	if "Levels" in scene_path and not "level_picker.tscn" in scene_path:
		for item in MainScene.get_meta("Stored_Scenes"):
			var split_path = str(scene_path.split("/")[6].split(".tscn")[0]).to_lower()
			print("Level to load: ", split_path)
			var itemName = str(item.get_name()).to_lower()
			if itemName == split_path:
				scene = item
				#MainScene.get_meta("Stored_Scenes").clear()
		
	if scene_holder.get_child_count() > 0:
		for child in scene_holder.get_children():
			scene_holder.remove_child(child)
			#child.queue_free()
			
	
	if not scene:
		var scene = load(scene_path)
		var scene_instance = scene.instantiate()
		scene_holder.add_child(scene_instance)
		
		if scene_instance.get_node("Player"):
			var scene_cam = scene_instance.get_node("Player/Cameras/MainCam")
		
			if scene_cam:
				scene_cam.make_current()
				scene_cam.position_smoothing_enabled = false
				await wait(0.1)
				scene_cam.position_smoothing_enabled = true
			else:
				push_error("Failed to recognize camera")
	elif scene:
		print("Scene Added! ", scene)
		scene_holder.add_child(scene)
		
		#MainScene.get_meta("Stored_Scenes").erase(scene)
		
		if scene.get_node("Player"):
			var scene_cam = scene.get_node("Player/Cameras/MainCam")
		
			if scene_cam:
				scene_cam.make_current()
				scene_cam.position_smoothing_enabled = false
				await wait(0.1)
				scene_cam.position_smoothing_enabled = true
				
			else:
				push_error("Failed to recognize camera")
		else:
			push_error("No Player!")
	else:
		print("Failed to load scene: ", scene_path)
	
func set_bus_volume_db(volume_db):
	main_audio.volume_db = volume_db
	
func wait(seconds):
	await get_tree().create_timer(seconds).timeout
