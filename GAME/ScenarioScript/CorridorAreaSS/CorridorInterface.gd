extends Control

@onready var fade = $Fade
@onready var animator = $AnimationFade
@onready var trans_button = $EnterBedroom/TransBedroom
@onready var enter1_sprite = $Enter_1

func _ready():
	animator.play("fade_in")

	enter1_sprite.modulate = Color(1, 1, 1, 0.2)

	trans_button.connect("mouse_entered", Callable(self, "_on_trans_hover_start"))
	trans_button.connect("mouse_exited", Callable(self, "_on_trans_hover_end"))

func _on_trans_hover_start():
	enter1_sprite.modulate = Color(1, 1, 1, 0.4)

func _on_trans_hover_end():
	enter1_sprite.modulate = Color(1, 1, 1, 0.2)

func _on_trans_bedroom_pressed():
	$DoorOpening.play()
	animator.play("transtion_bedroom")
	await animator.animation_finished
	get_tree().change_scene_to_file("res://ScenarioScript/BedroomAreaSS/bedroom_interface.tscn")
