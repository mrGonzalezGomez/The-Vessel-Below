extends CanvasLayer

const ITEM_SLOT_SCENE = preload("res://ScenarioScript/InventorySS/ItemSlot.tscn")

@onready var pages_section = $InventoryBackground/PagesSection
@onready var items_section = $InventoryBackground/ItemsSection
@onready var inventory_button = $InventoryButton
@onready var inventory_background = $InventoryBackground
@onready var inventory_open = $InventoryOpen
@onready var inventory_close = $InventoryClose
@onready var page_click = $PageClick
@onready var button = $Button
@onready var button2 = $Button2

var note_texts = {
		"English": "If you are reading this, that means that something very wrong happened and you have to escape. I left you a flashlight that could help you. May god help us and good luck.",
		"Francais": "Si vous lisez ceci, cela signifie que quelque chose de tres grave s'est produit et que vous devez vous echapper. Je vous ai laisse une lampe de poche qui pourrait vous aider. Que Dieu nous aide et bonne chance.",
		"Espanol": "Si estas leyendo esto, significa que algo muy malo ha sucedido y debes escapar. Te deje una linterna que podria ayudarte. Que Dios nos ayude y buena suerte."
}

var holloway_note_texts = {
		"English": "The lights... they flickered and died. Everything went silent. I felt like the whole world was waiting... Deck 4, Central Engine Room Access is a death trap. Avoid. Heard a sound like a ship's bell chiming repeatedly from the lower decks. -Rook.",
		"Francais": "Les lumieres... elles ont clignote et se sont eteintes. Tout est devenu silencieux. J'avais l'impression que le monde entier attendait... Pont 4, l'acces a la salle des machines centrale est un piege mortel. Evitez. J'ai entendu un son comme une cloche de navire sonner a plusieurs reprises depuis les ponts inferieurs. -Rook.",
		"Espanol": "Las luces... parpadearon y se apagaron. Todo quedo en silencio. Senti como si el mundo entier estuviera esperando... Cubierta 4, el acceso a la sala de maquinas central es una trampa mortal. Evitar. Escuche un sonido como el de una campana de barco sonando repetidamente desde las cubiertas inferiores. -Rook."
}

var button_visible := false
var button2_visible := false

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
		inventory_open.play()
		# Show the cursor while the inventory is open
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	else:
		inventory_background.mouse_filter = Control.MOUSE_FILTER_IGNORE
		inventory_close.play()
		# Hide the cursor when inventory is closed, only if player has the flashlight
		if InventoryManager.has_item("Flashlight"):
			Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)
	
	update_inventory_ui()

func update_inventory_ui():
	# Clear PagesSection
	if pages_section:
		pages_section.text = ""
		button_visible = false
		button2_visible = false

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

func _on_button_pressed() -> void:
	# Toggle note_texts display
	button_visible = !button_visible
	if button_visible:
		page_click.play()
		pages_section.text = note_texts.get(LanguageManager.current_lang, note_texts["English"])
	else:
		pages_section.text = ""

func _on_button_2_pressed() -> void:
	# Toggle holloway_note_texts display
	button2_visible = !button2_visible
	if button2_visible:
		page_click.play()
		pages_section.text = holloway_note_texts.get(LanguageManager.current_lang, holloway_note_texts["English"])
	else:
		pages_section.text = ""
