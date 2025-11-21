extends Control

@onready var fade = $Fade
@onready var animator = $AnimationFade
@onready var trans1_button = $EnterCorridor/TransCorridor
@onready var exit_sprite = $Exit
@onready var sparks_sound = $Sparks
@onready var metal_walking_sound = $MetalWalking

func _ready() -> void:
	ArrowManager.navigation_arrows.clear()
	ArrowManager.interaction_arrows.clear()
	# Register arrows in the global manager
	ArrowManager.register_arrow(exit_sprite, "navigation")
	ArrowManager.apply_mode(GameState.interface_mode)
	
	mouse_filter = Control.MOUSE_FILTER_IGNORE
	animator.play("fade_in")
	if sparks_sound:
		sparks_sound.volume_db = -10.0
		if sparks_sound.stream != null:
			sparks_sound.stream.loop = true
		if not sparks_sound.playing:
			sparks_sound.play()
	exit_sprite.modulate = Color(1, 1, 1, 0.2)
	
	if InventoryManager.is_item_picked_up("Radio"):
		$Radio.queue_free()

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
	RadioManager.maybe_play_random_sound()
	get_tree().change_scene_to_file("res://ScenarioScript/CorridorAreaSS/corridor_interface.tscn")

func _on_radio_input_event(_viewport: Node, event: InputEvent, _shape_idx: int) -> void:
	if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
		InventoryManager.add_item("Radio")
		$Radio.queue_free()
