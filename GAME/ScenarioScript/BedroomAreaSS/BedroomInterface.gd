extends Control

@onready var fade = $Fade
@onready var animator = $AnimationFade
@onready var trans_button = $ExitBedroom/TransCorridor
@onready var exit_sprite = $Exit

var note_texts = {
	"English": "If you are reading this, that means that something very wrong happened and you have to escape. I left you a flashlight that could help you. May god help us and good luck.",
	"Francais": "Si vous lisez ceci, cela signifie que quelque chose de tres grave s'est produit et que vous devez vous echapper. Je vous ai laisse une lampe de poche qui pourrait vous aider. Que Dieu nous aide et bonne chance.",
	"Espanol": "Si estas leyendo esto, significa que algo muy malo ha sucedido y debes escapar. Te deje una linterna que podria ayudarte. Que Dios nos ayude y buena suerte."
}

func _ready():
	ArrowManager.navigation_arrows.clear()
	ArrowManager.interaction_arrows.clear()
	# Register arrows in the global manager
	ArrowManager.register_arrow(exit_sprite, "navigation")
	ArrowManager.apply_mode(GameState.interface_mode)

	mouse_filter = Control.MOUSE_FILTER_IGNORE
	animator.play("fade_in")

	if InventoryManager.is_item_picked_up("Flashlight"):
		$Flashlight.queue_free()

	var current_lang = LanguageManager.current_lang
	var localized_note = note_texts.get(current_lang, note_texts["English"])

	if InventoryManager.is_note_picked_up(localized_note):
		$Note.queue_free()
	
	trans_button.connect("mouse_entered", Callable(self, "_on_trans_hover_start"))
	trans_button.connect("mouse_exited", Callable(self, "_on_trans_hover_end"))

	exit_sprite.modulate = Color(1, 1, 1, 0.2)

func _on_trans_hover_start():
	exit_sprite.modulate = Color(1, 1, 1, 0.4)

func _on_trans_hover_end():
	exit_sprite.modulate = Color(1, 1, 1, 0.2)

func _on_trans_corridor_pressed():
	$DoorClosing.play()
	animator.play("transition")
	await animator.animation_finished
	RadioManager.maybe_play_random_sound()
	get_tree().change_scene_to_file("res://ScenarioScript/CorridorAreaSS/corridor_interface.tscn")

func _on_note_input_event(_viewport, event, _shape_idx):
	if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
		var current_lang = LanguageManager.current_lang
		var localized_note = note_texts.get(current_lang, note_texts["English"])

		InventoryManager.add_note(localized_note)
		$Note.queue_free()

func _on_flashlight_input_event(_viewport, event, _shape_idx):
	if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
		InventoryManager.add_item("Flashlight")
		$Flashlight.queue_free()

		Flashlight.light.visible = true
		Flashlight.dot.visible = true

		Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)
