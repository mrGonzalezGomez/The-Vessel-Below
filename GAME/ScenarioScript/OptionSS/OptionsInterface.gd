extends Control

var resolutions = [
	Vector2i(1280, 720),
	Vector2i(1600, 900),
	Vector2i(1920, 1080),
	Vector2i(2560, 1440)
]

var current_resolution_index := 0
var languages = ["English", "Francais", "Espanol"]
var lang_index := 0

func _ready():
	_update_texts()

	var current_size = DisplayServer.window_get_size()
	for i in range(resolutions.size()):
		if resolutions[i] == current_size:
			current_resolution_index = i
			break

	var res = resolutions[current_resolution_index]
	$ResolutionText.text = str(res.x) + " x " + str(res.y)
	
	# Show current language on startup
	$LanguageChoice.text = languages[lang_index]

func _update_texts():
	$VBoxContainer/BrightnessButton.text = LanguageManager.t("settings_brightness")
	$VBoxContainer/MusicButton.text = LanguageManager.t("settings_music")
	$VBoxContainer/VideoButton.text = LanguageManager.t("settings_video")
	$VBoxContainer/LanguageButton.text = LanguageManager.t("settings_language")
	$VBoxContainer/ReturnButton.text = LanguageManager.t("menu_quit")
	
	# Update language choice label
	$LanguageChoice.text = languages[lang_index]

func _on_brightness_button_pressed():
	$ClickSound.play()

	# Toggle between 0 and -40
	if $BrightSlider.value == 0:
		$BrightSlider.value = -40
	else:
		$BrightSlider.value = 0

	# Apply the brightness
	BrightnessOverlay.set_brightness($BrightSlider.value)

func _on_music_button_pressed():
	$ClickSound.play()
	
	var music_bus_index = AudioServer.get_bus_index("Menu Music")

	# If slider is already at max, set it to min, otherwise set it to max
	if $MusicSlider.value >= 0:
		$MusicSlider.value = -40   # silence
	else:
		$MusicSlider.value = 0     # full volume

	# Apply the slider's value to the audio bus
	AudioServer.set_bus_volume_db(music_bus_index, $MusicSlider.value)

	# Update percentage label
	$MusicPercent.text = str(round(($MusicSlider.value + 40) * 2.5)) + " %"

func _on_video_button_pressed():
	$ClickSound.play()
	current_resolution_index = (current_resolution_index + 1) % resolutions.size()
	var res = resolutions[current_resolution_index]
	
	# Only apply resize if window is not embedded in the editor
	if not Engine.is_editor_hint():
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
		DisplayServer.window_set_size(res)
	else:
		print("Skipping resize in editor (embedded window)")

	$ResolutionText.text = str(res.x) + " x " + str(res.y)

func _on_return_button_pressed():
	$ClickSound.play()
	get_tree().change_scene_to_file("res://ScenarioScript/MenuSS/menu_interface.tscn")

func _on_bright_slider_value_changed(value):
	BrightnessOverlay.set_brightness(value)
	$BrightnessPercent.text = str(round((value + 40) * 2.5)) + " %"

func _on_music_slider_value_changed(value):
	var music_bus_index = AudioServer.get_bus_index("Menu Music")
	AudioServer.set_bus_volume_db(music_bus_index, value)
	
	$MusicPercent.text = str(round((value + 40) * 2.5)) + " %"

func _on_language_button_pressed():
	$ClickSound.play()
	lang_index = (lang_index + 1) % languages.size()
	LanguageManager.set_language(languages[lang_index])
	_update_texts()
