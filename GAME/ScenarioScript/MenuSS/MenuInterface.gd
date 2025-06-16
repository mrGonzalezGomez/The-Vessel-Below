extends Control

@onready var fade = $Fade
@onready var animator = $AnimationFade

func _on_game_button_pressed():
	$PlaySound.play()
	animator.play("fade_out")

func _on_options_button_pressed():
	$ClickSound.play()
	get_tree().change_scene_to_file("res://ScenarioScript/OptionSS/options_interface.tscn")

func _on_quit_button_pressed():
	$ClickSound.play()
	get_tree().quit()

func _on_animation_fade_animation_finished(anim_name):
	if anim_name == "fade_out":
		get_tree().change_scene_to_file("res://ScenarioScript/PrologueSS/prologue_interface.tscn")
