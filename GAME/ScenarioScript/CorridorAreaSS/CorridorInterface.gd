extends Control

@onready var fade = $Fade
@onready var animator = $AnimationFade
@onready var trans1_button = $EnterBedroom/TransBedroom
@onready var trans2_button = $EnterMaintenance/TransMaintenance
@onready var enter1_sprite = $Enter_1
@onready var enter2_sprite = $Enter_2
@onready var glitch_sound = $GlitchLight
@onready var flashlight = Flashlight
@onready var brightness_overlay = BrightnessOverlay

var flicker_active := false
var flicker_timer := 0.0
var normal_brightness := 0.0
var normal_light_energy := 0.0
var normal_dot_energy := 0.0

func _ready():
	animator.play("fade_in")

	enter1_sprite.modulate = Color(1, 1, 1, 0.2)
	enter2_sprite.modulate = Color(1, 1, 1, 0.2)

	trans1_button.connect("mouse_entered", Callable(self, "_on_trans_bedroom_hover_start"))
	trans1_button.connect("mouse_exited", Callable(self, "_on_trans_bedroom_hover_end"))
	
	trans2_button.connect("mouse_entered", Callable(self, "_on_trans_maintenance_hover_start"))
	trans2_button.connect("mouse_exited", Callable(self, "_on_trans_maintenance_hover_end"))
	
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
	get_tree().change_scene_to_file("res://ScenarioScript/BedroomAreaSS/bedroom_interface.tscn")

func _on_trans_maintenance_pressed():
	$MetalWalking.play()
	animator.play("transtion_bedroom")
	await animator.animation_finished
	get_tree().change_scene_to_file("res://ScenarioScript/MaintenanceAreaSS/maintenance_interface.tscn")
