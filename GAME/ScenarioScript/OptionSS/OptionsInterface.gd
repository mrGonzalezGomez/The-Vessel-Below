extends Control

var resolutions = [
	Vector2i(1280, 720),
	Vector2i(1600, 900),
	Vector2i(1920, 1080),
	Vector2i(2560, 1440)
]

var current_resolution_index := 0

func _ready():
	var current_size = DisplayServer.window_get_size()
	for i in range(resolutions.size()):
		if resolutions[i] == current_size:
			current_resolution_index = i
			break

	var res = resolutions[current_resolution_index]
	$ResolutionText.text = str(res.x) + " x " + str(res.y)

func _on_music_button_pressed():
	$ClickSound.play()
	var music_bus_index = AudioServer.get_bus_index("Menu Music")
	var is_muted = AudioServer.is_bus_mute(music_bus_index)
	AudioServer.set_bus_mute(music_bus_index, not is_muted)

func _on_video_button_pressed():
	$ClickSound.play()
	current_resolution_index += 1
	if current_resolution_index >= resolutions.size():
		current_resolution_index = 0

	var res = resolutions[current_resolution_index]
	DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
	DisplayServer.window_set_size(res)
	print("Resolution set to: ", res)
	
	$ResolutionText.text = str(res.x) + " x " + str(res.y)

func _on_subtitles_button_pressed():
	$ClickSound.play()

func _on_return_button_pressed():
	$ClickSound.play()
	get_tree().change_scene_to_file("res://ScenarioScript/MenuSS/menu_interface.tscn")

func _on_music_slider_value_changed(value):
	var music_bus_index = AudioServer.get_bus_index("Menu Music")
	AudioServer.set_bus_volume_db(music_bus_index, value)
	
	$MusicPercent.text = str(round((value + 40) * 2.5)) + " %"
