extends Control

@onready var fade = $Fade
@onready var animator = $AnimationFade
@onready var trans1_button = $EnterCreature/TransCreature
@onready var trans2_button = $EnterMotor/TransMotor
@onready var exit_sprite = $Exit
@onready var enter_sprite = $Enter
@onready var glitch_sound = $GlitchLight
@onready var flashlight = Flashlight
@onready var brightness_overlay = BrightnessOverlay
@onready var build_up_music = $BuildUpMusic
@onready var scratching = $Scratching
@onready var flesh = $Flesh
@onready var dark_overlay = $DarkOverlay

var flicker_active := false
var flicker_timer := 0.0
var normal_brightness := 0.0
var normal_light_energy := 0.0
var normal_dot_energy := 0.0

func _ready() -> void:
	# ARROW SYSTEM
	ArrowManager.navigation_arrows.clear()
	ArrowManager.interaction_arrows.clear()
	ArrowManager.register_arrow(exit_sprite, "navigation")
	ArrowManager.register_arrow(enter_sprite, "navigation")
	ArrowManager.apply_mode(GameState.interface_mode)
	
	animator.play("fade_in")
	
	exit_sprite.modulate = Color(1, 1, 1, 0.4)
	enter_sprite.modulate = Color(1, 1, 1, 0.4)
	
	trans1_button.connect("mouse_entered", Callable(self, "_on_trans_creature_hover_start"))
	trans1_button.connect("mouse_exited", Callable(self, "_on_trans_creature_hover_end"))
	
	trans2_button.connect("mouse_entered", Callable(self, "_on_trans_motor_hover_start"))
	trans2_button.connect("mouse_exited", Callable(self, "_on_trans_motor_hover_end"))
	
	if build_up_music:
		build_up_music.play()
	if scratching:
		scratching.play()
	if flesh:
		flesh.play()
	set_process(false)
	
	dark_overlay.color = Color(0, 0, 0, 0.7)

func _process(delta: float) -> void:
	if flicker_active:
		flicker_timer -= delta
		if flicker_timer <= 0.0:
			flicker_timer = randf_range(0.05, 0.2)
			var new_brightness = randf_range(-40.0, -5.0)
			var light_flick = randf_range(0.3, 1.2)
			brightness_overlay.set_brightness(new_brightness)
			flashlight.light.energy = light_flick * 2.0
			flashlight.dot.energy = light_flick * 1.75

func _on_trans_creature_hover_start():
	enter_sprite.modulate = Color(1, 1, 1, 0.6)

	flicker_active = true
	flicker_timer = 0.0
	set_process(true)

	normal_brightness = brightness_overlay.brightness_level
	normal_light_energy = flashlight.light.energy
	normal_dot_energy = flashlight.dot.energy

	if glitch_sound:
		glitch_sound.play()

func _on_trans_creature_hover_end():
	enter_sprite.modulate = Color(1, 1, 1, 0.4)

	flicker_active = false
	set_process(false)

	flashlight.light.energy = normal_light_energy
	flashlight.dot.energy = normal_dot_energy
	brightness_overlay.set_brightness(normal_brightness)

	if glitch_sound:
		glitch_sound.stop()

func _on_trans_motor_hover_start():
	exit_sprite.modulate = Color(1, 1, 1, 0.6)

func _on_trans_motor_hover_end():
	exit_sprite.modulate = Color(1, 1, 1, 0.4)

func _on_trans_creature_pressed() -> void:
	$MetalWalking.play()
	animator.play("transtion_bedroom")
	await animator.animation_finished
	RadioManager.maybe_play_random_sound()
	get_tree().change_scene_to_file("res://ScenarioScript/CreatureRoomSS/creature_interface.tscn")

func _on_trans_motor_pressed() -> void:
	$MetalWalking.play()
	animator.play("transtion_bedroom")
	await animator.animation_finished
	RadioManager.maybe_play_random_sound()
	get_tree().change_scene_to_file("res://ScenarioScript/MotorRoomSS/motor_interface.tscn")
