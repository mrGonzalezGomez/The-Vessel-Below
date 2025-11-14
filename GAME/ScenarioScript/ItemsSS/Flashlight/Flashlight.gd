extends CanvasLayer

@onready var light: PointLight2D = $PointLight2D
@onready var dot: PointLight2D = $PointLight2D2
@onready var click_sound = $FlashlightClick

const RESTRICTED_SCENES = [
	"menu_interface.tscn",
	"options_interface.tscn",
	"prologue_interface.tscn",
	"maintenancedialogue_interface.tscn",
]

func _ready():
	# Tune light properties
	light.energy = 2.0
	dot.energy = 1.75
	light.color = Color(1, 1, 1)
	light.scale = Vector2(1.5, 1.5)
	
	# Hide light and dot unless player has the flashlight
	var has_flashlight = InventoryManager.is_item_picked_up("Flashlight")
	light.visible = has_flashlight
	dot.visible = has_flashlight

func _is_in_game_scene() -> bool:
	var current_scene = get_tree().current_scene
	if not current_scene:
		return false
	
	var current_scene_file = current_scene.scene_file_path.get_file()
	return not (current_scene_file in RESTRICTED_SCENES)

func _input(event):
	# Check if the player has the flashlight and the light node is valid
	if not InventoryManager.is_item_picked_up("Flashlight") or not is_instance_valid(light):
		return

	# Check if the current scene is valid
	if not _is_in_game_scene():
		return
	
	# Check for Right Mouse Button click (MOUSE_BUTTON_RIGHT) or a custom Action
	if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_RIGHT:
		toggle_active()
		get_viewport().set_input_as_handled()

func _process(_delta):
	if not light.visible: return
	
	# Make flashlight follow the cursor
	var mouse_pos = get_viewport().get_mouse_position()
	light.global_position = mouse_pos
	dot.global_position = mouse_pos

func toggle_active():
	var new_visibility = !light.visible
	
	light.visible = new_visibility
	dot.visible = new_visibility

	if click_sound:
		click_sound.play()
	
	if new_visibility:
		Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)
	else:
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
