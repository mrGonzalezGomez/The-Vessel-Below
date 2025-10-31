extends Control

@onready var fade = $Fade
@onready var animator = $AnimationFade
@onready var trans1_button = $EnterCorridor/TransCorridor
@onready var exit_sprite = $Exit
@onready var sparks_sound = $Sparks
@onready var metal_walking_sound = $MetalWalking

func _ready() -> void:
	animator.play("fade_in")
	if sparks_sound:
		sparks_sound.volume_db = -10.0
		if sparks_sound.stream != null:
			sparks_sound.stream.loop = true
		if not sparks_sound.playing:
			sparks_sound.play()
	exit_sprite.modulate = Color(1, 1, 1, 0.2)

	trans1_button.connect("mouse_entered", Callable(self, "_on_trans_corridor_hover_start"))
	trans1_button.connect("mouse_exited", Callable(self, "_on_trans_corridor_hover_end"))

func _on_trans_corridor_hover_start():
	exit_sprite.modulate = Color(1, 1, 1, 0.4)

func _on_trans_corridor_hover_end():
	exit_sprite.modulate = Color(1, 1, 1, 0.2)

func _on_trans_corridor_pressed():
	if sparks_sound:
			sparks_sound.stop()
	metal_walking_sound.play()
	animator.play("transtion_bedroom")
	await animator.animation_finished
	get_tree().change_scene_to_file("res://ScenarioScript/CorridorAreaSS/corridor_interface.tscn")
