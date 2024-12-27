extends Node

func dir_contents(dir):
	var contents = []
	
	if dir:
		dir.list_dir_begin()
		var file_name = dir.get_next()
		while file_name != "":
			if not dir.current_is_dir():
				if not ".import" in file_name:
					contents.append(file_name)
			file_name = dir.get_next()
		return contents
	
func pick_random_sound(dir):
	var contents = dir_contents(dir)
	var randomChoice = contents.pick_random()
	
	return randomChoice
	
func play_SFX_varied(audio_player, track, min_pitch, max_pitch, min_volume, max_volume):
	audio_player.stream = track
	audio_player.pitch_scale = randf_range(min_pitch, max_pitch)
	audio_player.volume_db = randf_range(min_volume, max_volume)
	audio_player.play()
	
func wait(time):
	get_tree().create_timer(time).timeout
