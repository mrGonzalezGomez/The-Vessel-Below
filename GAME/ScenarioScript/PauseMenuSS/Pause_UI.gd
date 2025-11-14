extends CanvasLayer

func _ready() -> void:
	self.visible = false
	LanguageManager.connect("language_changed", _update_texts)
	_update_texts()

func _update_texts():
	$VBoxContainer/PauseTitle.text = LanguageManager.t("ingame_title")
	$VBoxContainer2/ResumeButton.text = LanguageManager.t("ingame_resume")
	$VBoxContainer2/OptionsButton.text = LanguageManager.t("ingame_settings")
	$VBoxContainer2/QuitButton.text = LanguageManager.t("ingame_quit")

func _input(event):
	if event.is_action_pressed("ui_cancel"):
		if _can_pause_current_scene():
			if self.visible:
				_unpause_game()
			else:
				_pause_game()
			get_viewport().set_input_as_handled()

func _pause_game():
	get_tree().paused = true
	self.visible = true
	
	if is_instance_valid(PausePlayer):
		PausePlayer.play_music()
	
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)

func _unpause_game():
	get_tree().paused = false
	self.visible = false
	
	if is_instance_valid(PausePlayer):
		PausePlayer.stop_music()

func _can_pause_current_scene() -> bool:
	var current_scene = get_tree().current_scene
	if not current_scene:
		return false

	var restricted_scenes = [
		"menu_interface.tscn",
		"options_interface.tscn",
		"prologue_interface.tscn",
        "maintenancedialogue_interface.tscn" 
	]
	
	var current_scene_path = current_scene.scene_file_path.get_file()

	for scene_name in restricted_scenes:
		if current_scene_path == scene_name:
			return false
			
	return true

func _on_resume_button_pressed() -> void:
	$ClickSound.play()
	_unpause_game()

func _on_options_button_pressed() -> void:
	pass

func _on_quit_button_pressed() -> void:
	$ClickSound.play()
	get_tree().paused = false
	
	if is_instance_valid(PausePlayer):
		PausePlayer.stop_music()
	get_tree().change_scene_to_file("res://ScenarioScript/MenuSS/menu_interface.tscn")
	_unpause_game()
