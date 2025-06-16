extends Control

@onready var fade = $Fade
@onready var animator = $AnimationFade

func _ready():
	animator.play("fade_in")

func _on_trans_bedroom_pressed():
	$DoorOpening.play()
	animator.play("transtion_bedroom")
	await animator.animation_finished
	get_tree().change_scene_to_file("res://ScenarioScript/BedroomAreaSS/bedroom_interface.tscn")
