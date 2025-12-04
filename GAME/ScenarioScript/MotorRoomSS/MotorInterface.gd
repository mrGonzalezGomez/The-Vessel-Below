extends Control

@onready var fade = $Fade
@onready var animator = $AnimationFade
@onready var trans1_button = $EnterStairs/TransStairs
@onready var exit_sprite = $Exit
@onready var valve = $Valve
@onready var pull_cord = $PullCord
@onready var rotation_button = $RotationAction
@onready var pull_button = $PullAction
@onready var turn_on_sound = $TurnOnSound
@onready var turn_off_sound = $TurnOffSound
@onready var pull_sound = $PullSound
@onready var motor_sound = $MotorSound

var steam_on := false
var motor_on := false

var rotation_hold_time := 0.0
var pull_hold_time := 0.0

var rotation_holding := false
var pull_holding := false

const TIME_TO_TURN_ON = 4.0
const TIME_TO_TURN_OFF = 2.0
const TIME_TO_PULL_MOTOR = 7.0

func _ready() -> void:
	# ARROW SYSTEM
	ArrowManager.navigation_arrows.clear()
	ArrowManager.interaction_arrows.clear()
	ArrowManager.register_arrow(exit_sprite, "navigation")
	ArrowManager.apply_mode(GameState.interface_mode)
	
	animator.play("fade_in")
	
	exit_sprite.modulate = Color(1, 1, 1, 0.4)
	
	trans1_button.connect("mouse_entered", Callable(self, "_on_trans_stairs_hover_start"))
	trans1_button.connect("mouse_exited", Callable(self, "_on_trans_stairs_hover_end"))

	rotation_button.connect("button_down", Callable(self, "_on_rotation_start"))
	rotation_button.connect("button_up", Callable(self, "_on_rotation_stop"))

	pull_button.connect("button_down", Callable(self, "_on_pull_start"))
	pull_button.connect("button_up", Callable(self, "_on_pull_stop"))

func _process(delta: float) -> void:

	if rotation_holding:
		rotation_hold_time += delta

		if not steam_on and rotation_hold_time >= TIME_TO_TURN_ON:
			steam_on = true
			rotation_holding = false
			turn_on_sound.stop()
			print("SteamOn ACTIVATED")

		elif steam_on and rotation_hold_time >= TIME_TO_TURN_OFF:
			steam_on = false
			rotation_holding = false
			turn_off_sound.stop()
			print("SteamOff ACTIVATED")

	if pull_holding:
		pull_hold_time += delta

		if not motor_on and pull_hold_time >= TIME_TO_PULL_MOTOR:
			motor_on = true
			pull_holding = false
			pull_sound.stop()
			print("MotorOn ACTIVATED")

			motor_sound.play()

func _on_rotation_start():
	rotation_holding = true
	rotation_hold_time = 0.0

	if steam_on:
		turn_off_sound.play()
	else:
		turn_on_sound.play()


func _on_rotation_stop():
	rotation_holding = false
	rotation_hold_time = 0.0

	turn_on_sound.stop()
	turn_off_sound.stop()

func _on_pull_start():
	if motor_on:
		return

	pull_holding = true
	pull_hold_time = 0.0
	pull_sound.play()


func _on_pull_stop():
	if motor_on:
		return

	pull_holding = false
	pull_hold_time = 0.0
	pull_sound.stop()

func _on_trans_stairs_hover_start():
	exit_sprite.modulate = Color(1, 1, 1, 0.6)

func _on_trans_stairs_hover_end():
	exit_sprite.modulate = Color(1, 1, 1, 0.4)

func _on_trans_stairs_pressed() -> void:
	$MetalStairs.play()
	animator.play("transtion_bedroom")
	await animator.animation_finished
	RadioManager.maybe_play_random_sound()
	get_tree().change_scene_to_file("res://ScenarioScript/MotorStairsSS/motorstairs_interface.tscn")
