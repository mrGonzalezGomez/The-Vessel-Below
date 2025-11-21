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
var arrow_modes = ["Immersive", "Guided", "Complete"]
var arrow_mode_index := 0

# Helper function to apply volume to ALL relevant Audio Buses and update the UI label
func _apply_music_volume(value: float):
	# 1. Control the Menu Music bus (for Main Menu music)
	var menu_music_bus_index = AudioServer.get_bus_index("Menu Music")
	if menu_music_bus_index != -1:
		AudioServer.set_bus_volume_db(menu_music_bus_index, value)
	else:
		print("Warning: Audio Bus 'Menu Music' not found!")
	
	# 2. Control the Pause Music bus
	var pause_music_bus_index = AudioServer.get_bus_index("Pause Music")
	if pause_music_bus_index != -1:
		AudioServer.set_bus_volume_db(pause_music_bus_index, value)
	else:
		# If this bus is missing, the music will still be audible at 0%
		print("Warning: Audio Bus 'Pause Music' not found! Pause music will not be controlled.")
	
	$MusicPercent.text = str(round((value + 40) * 2.5)) + " %"

func _ready():
	_update_texts()

	var current_size = DisplayServer.window_get_size()
	for i in range(resolutions.size()):
		if resolutions[i] == current_size:
			current_resolution_index = i
			break

	var res = resolutions[current_resolution_index]
	$ResolutionText.text = str(res.x) + " x " + str(res.y)
	
	# Initial volume check: Read volume from a bus and apply it (to update the label and buses)
	var music_bus_index = AudioServer.get_bus_index("Menu Music")
	if music_bus_index != -1:
		$MusicSlider.value = AudioServer.get_bus_volume_db(music_bus_index)
	_apply_music_volume($MusicSlider.value)
	
	# Show current language on startup
	$LanguageChoice.text = languages[lang_index]
	
	# Show current accessibility on startup
	$ArrowChoice.text = arrow_modes[arrow_mode_index]

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

	if $BrightSlider.value == 0:
		$BrightSlider.value = -40
	else:
		$BrightSlider.value = 0

	BrightnessOverlay.set_brightness($BrightSlider.value)

func _on_music_button_pressed():
	$ClickSound.play()
	
	if $MusicSlider.value >= 0:
		$MusicSlider.value = -40
	else:
		$MusicSlider.value = 0

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
	_apply_music_volume(value)

func _on_language_button_pressed():
	$ClickSound.play()
	lang_index = (lang_index + 1) % languages.size()
	LanguageManager.set_language(languages[lang_index])
	_update_texts()

func _on_accessibility_button_pressed() -> void:
	$ClickSound.play()
	arrow_mode_index = (arrow_mode_index + 1) % arrow_modes.size()
	$ArrowChoice.text = arrow_modes[arrow_mode_index]

	var mode = arrow_modes[arrow_mode_index].to_lower()
	GameState.interface_mode = mode
	ArrowManager.apply_mode(mode)
