extends Control

@onready var fade = $Fade
@onready var animator = $AnimationFade

func _ready():
	mouse_filter = Control.MOUSE_FILTER_IGNORE
	animator.play("fade_in")

	if InventoryManager.is_item_picked_up("Toolbox"):
		$Toolbox.queue_free()
	
	if InventoryManager.is_note_picked_up("If you are reading this, that means that something very wrong happened and you have to escape. I left you a toolbox with some utils that could help you. May god help us and good luck."):
		$Note.queue_free()

func _on_trans_corridor_pressed():
	$DoorClosing.play()
	animator.play("transition")
	await animator.animation_finished
	get_tree().change_scene_to_file("res://ScenarioScript/CorridorAreaSS/corridor_interface.tscn")

func _on_toolbox_input_event(_viewport, event, _shape_idx):
	if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
		InventoryManager.add_item("Toolbox")
		$Toolbox.queue_free()

func _on_note_input_event(_viewport, event, _shape_idx):
	if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
		InventoryManager.add_note("If you are reading this, that means that something very wrong happened and you have to escape. I left you a toolbox with some utils that could help you. May god help us and good luck.")
		$Note.queue_free()
