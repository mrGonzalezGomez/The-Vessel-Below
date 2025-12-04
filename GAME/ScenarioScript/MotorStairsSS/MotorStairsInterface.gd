extends Control

@onready var fade = $Fade
@onready var animator = $AnimationFade
@onready var trans1_button = $EnterCorridor/TransCorridor
@onready var trans2_button = $EnterMotor/TransMotor
@onready var exit_sprite = $Exit
@onready var enter_sprite = $Enter

func _ready() -> void:
	ArrowManager.navigation_arrows.clear()
	ArrowManager.interaction_arrows.clear()
	# Register arrows in the global manager
	ArrowManager.register_arrow(exit_sprite, "navigation")
	ArrowManager.register_arrow(enter_sprite, "navigation")
	ArrowManager.apply_mode(GameState.interface_mode)
	
	animator.play("fade_in")
	
	exit_sprite.modulate = Color(1, 1, 1, 0.4)
	enter_sprite.modulate = Color(1, 1, 1, 0.4)
	
	trans1_button.connect("mouse_entered", Callable(self, "_on_trans_corridor_hover_start"))
	trans1_button.connect("mouse_exited", Callable(self, "_on_trans_corridor_hover_end"))
	trans2_button.connect("mouse_entered", Callable(self, "_on_trans_motor_hover_start"))
	trans2_button.connect("mouse_exited", Callable(self, "_on_trans_motor_hover_end"))
	
func _on_trans_corridor_hover_start():
	exit_sprite.modulate = Color(1, 1, 1, 0.6)

func _on_trans_corridor_hover_end():
	exit_sprite.modulate = Color(1, 1, 1, 0.4)

func _on_trans_motor_hover_start():
	enter_sprite.modulate = Color(1, 1, 1, 0.6)

func _on_trans_motor_hover_end():
	enter_sprite.modulate = Color(1, 1, 1, 0.4)

func _on_trans_corridor_pressed() -> void:
	$MetalWalking.play()
	animator.play("transtion_bedroom")
	await animator.animation_finished
	RadioManager.maybe_play_random_sound()
	get_tree().change_scene_to_file("res://ScenarioScript/CorridorAreaSS/corridor_interface.tscn")

func _on_trans_motor_pressed() -> void:
	$MetalStairs.play()
	animator.play("transtion_bedroom")
	await animator.animation_finished
	RadioManager.maybe_play_random_sound()
	get_tree().change_scene_to_file("res://ScenarioScript/MotorRoomSS/motor_interface.tscn")
