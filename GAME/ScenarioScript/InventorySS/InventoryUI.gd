extends CanvasLayer

const ITEM_SLOT_SCENE = preload("res://ScenarioScript/InventorySS/ItemSlot.tscn")

@onready var pages_section = $InventoryBackground/PagesSection
@onready var items_section = $InventoryBackground/ItemsSection
@onready var inventory_button = $InventoryButton
@onready var inventory_background = $InventoryBackground
@onready var inventory_sound = $InventorySound

func _ready():
	inventory_background.visible = false
	inventory_background.mouse_filter = Control.MOUSE_FILTER_IGNORE
	inventory_button.pressed.connect(_on_inventory_button_pressed)
	update_inventory_ui()

func _input(event):
	if event.is_action_pressed("toggle_inventory"):
		toggle_inventory()

func _on_inventory_button_pressed():
	toggle_inventory()

func toggle_inventory():
	inventory_background.visible = !inventory_background.visible

	if inventory_background.visible:
		inventory_background.mouse_filter = Control.MOUSE_FILTER_STOP
		inventory_sound.play()
	else:
		inventory_background.mouse_filter = Control.MOUSE_FILTER_IGNORE
	update_inventory_ui()

func update_inventory_ui():
	pages_section.text = ""
	for note in InventoryManager.notes:
		pages_section.text += "- " + note + "\n"

	for child in items_section.get_children():
		child.queue_free()

	for item in InventoryManager.items:
		var slot = ITEM_SLOT_SCENE.instantiate()
		slot.set_item(item)
		items_section.add_child(slot)

func _process(_delta):
	var current_scene = get_tree().current_scene
	if not current_scene:
		return

	var hidden_scenes = [
		"menu_interface.tscn",
		"options_interface.tscn",
		"prologue_interface.tscn"
	]

	var should_hide = false
	for scene_name in hidden_scenes:
		if current_scene.scene_file_path.ends_with(scene_name):
			should_hide = true
			break

	inventory_button.visible = not should_hide
