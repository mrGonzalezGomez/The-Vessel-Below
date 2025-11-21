extends Control

@onready var fade = $Fade
@onready var animator = $AnimationFade
@onready var trans1_button = $EnterBedroom/TransBedroom
@onready var trans2_button = $EnterMaintenance/TransMaintenance
@onready var trans3_button = $EnterMotorStairs/TransMotorStairs
@onready var trans4_button = $EnterDarkCorridor/TransDarkCorridor
@onready var enter1_sprite = $Enter_1
@onready var enter2_sprite = $Enter_2
@onready var enter3_sprite = $Enter_3
@onready var enter4_sprite = $Enter_4
@onready var glitch_sound = $GlitchLight
@onready var flashlight = Flashlight
@onready var brightness_overlay = BrightnessOverlay

var flicker_active := false
var flicker_timer := 0.0
var normal_brightness := 0.0
var normal_light_energy := 0.0
var normal_dot_energy := 0.0

func _ready():
	ArrowManager.navigation_arrows.clear()
	ArrowManager.interaction_arrows.clear()
	# Register arrows in the global manager
	ArrowManager.register_arrow(enter1_sprite, "navigation")
	ArrowManager.register_arrow(enter2_sprite, "navigation")
	ArrowManager.register_arrow(enter3_sprite, "navigation")
	ArrowManager.register_arrow(enter4_sprite, "navigation")
	ArrowManager.apply_mode(GameState.interface_mode)

	animator.play("fade_in")

	enter1_sprite.modulate = Color(1, 1, 1, 0.2)
	enter2_sprite.modulate = Color(1, 1, 1, 0.2)
	enter3_sprite.modulate = Color(1, 1, 1, 0.2)
	enter4_sprite.modulate = Color(1, 1, 1, 0.2)

	trans1_button.connect("mouse_entered", Callable(self, "_on_trans_bedroom_hover_start"))
	trans1_button.connect("mouse_exited", Callable(self, "_on_trans_bedroom_hover_end"))
	
	trans2_button.connect("mouse_entered", Callable(self, "_on_trans_maintenance_hover_start"))
	trans2_button.connect("mouse_exited", Callable(self, "_on_trans_maintenance_hover_end"))
	
	trans3_button.connect("mouse_entered", Callable(self, "_on_trans_mstairs_hover_start"))
	trans3_button.connect("mouse_exited", Callable(self, "_on_trans_mstairs_hover_end"))
	
	trans4_button.connect("mouse_entered", Callable(self, "_on_trans_dcorridor_hover_start"))
	trans4_button.connect("mouse_exited", Callable(self, "_on_trans_dcorridor_hover_end"))
	
	set_process(false)

func _on_trans_bedroom_hover_start():
	enter1_sprite.modulate = Color(1, 1, 1, 0.4)

func _on_trans_bedroom_hover_end():
	enter1_sprite.modulate = Color(1, 1, 1, 0.2)

func _on_trans_maintenance_hover_start():
	enter2_sprite.modulate = Color(1, 1, 1, 0.4)
	flicker_active = true
	flicker_timer = 0.0
	set_process(true)

	normal_brightness = brightness_overlay.brightness_level
	normal_light_energy = flashlight.light.energy
	normal_dot_energy = flashlight.dot.energy

	if glitch_sound:
		glitch_sound.play()

func _on_trans_maintenance_hover_end():
	enter2_sprite.modulate = Color(1, 1, 1, 0.2)
	flicker_active = false
	set_process(false)

	flashlight.light.energy = normal_light_energy
	flashlight.dot.energy = normal_dot_energy
	brightness_overlay.set_brightness(normal_brightness)

	if glitch_sound:
		glitch_sound.stop()

func _on_trans_mstairs_hover_start():
	enter3_sprite.modulate = Color(1, 1, 1, 0.4)

func _on_trans_mstairs_hover_end():
	enter3_sprite.modulate = Color(1, 1, 1, 0.2)

func _on_trans_dcorridor_hover_start():
	enter4_sprite.modulate = Color(1, 1, 1, 0.4)

func _on_trans_dcorridor_hover_end():
	enter4_sprite.modulate = Color(1, 1, 1, 0.2)

func _process(delta):
	if flicker_active:
		flicker_timer -= delta
		if flicker_timer <= 0.0:
			flicker_timer = randf_range(0.05, 0.2)
			var new_brightness = randf_range(-40.0, -5.0)
			var light_flicker = randf_range(0.3, 1.2)

			brightness_overlay.set_brightness(new_brightness)
			flashlight.light.energy = light_flicker * 2.0
			flashlight.dot.energy = light_flicker * 1.75

func _on_trans_bedroom_pressed():
	$DoorOpening.play()
	animator.play("transtion_bedroom")
	await animator.animation_finished
	RadioManager.maybe_play_random_sound()
	get_tree().change_scene_to_file("res://ScenarioScript/BedroomAreaSS/bedroom_interface.tscn")

func _on_trans_maintenance_pressed():
	$MetalWalking.play()
	animator.play("transtion_bedroom")
	await animator.animation_finished
	RadioManager.maybe_play_random_sound()
	get_tree().change_scene_to_file("res://ScenarioScript/MaintenanceAreaSS/maintenance_interface.tscn")

func _on_trans_motor_stairs_pressed() -> void:
	$MetalWalking.play()
	animator.play("transtion_bedroom")
	await animator.animation_finished
	RadioManager.maybe_play_random_sound()
	get_tree().change_scene_to_file("res://ScenarioScript/MotorStairsSS/motorstairs_interface.tscn")

func _on_trans_dark_corridor_pressed() -> void:
	$MetalWalking.play()
	animator.play("transtion_bedroom")
	await animator.animation_finished
	RadioManager.maybe_play_random_sound()
	get_tree().change_scene_to_file("res://ScenarioScript/DarkCorridorSS/darkcorridor_interface.tscn")
