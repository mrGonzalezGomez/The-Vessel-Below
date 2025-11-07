extends Control

@export var dialogPath = "res://Assets/Dialogue/JsonFiles/MaintenanceRoom/HollowayDialogue.json"
@export var textSpeed = 0.05
@export var nextScenePath = "res://ScenarioScript/MaintenanceAreaSS/maintenance_interface.tscn"

@onready var fade = $Fade
@onready var animator = $AnimationFade
@onready var choice_box = $ChoiceBox
@onready var name_box = $DialogueBox/NameBox
@onready var text_box = $DialogueBox/TextBox
@onready var npc_death_sound = $NpcDeath

var holloway_note_texts = {
	"English": "The lights... they flickered and died. Everything went silent. I felt like the whole world was waiting... Deck 4, Central Engine Room Access is a death trap. Avoid. Heard a sound like a ship's bell chiming repeatedly from the lower decks. -Rook.",
	"Francais": "Les lumieres... elles ont clignote et se sont eteintes. Tout est devenu silencieux. J'avais l'impression que le monde entier attendait... Pont 4, l'acces a la salle des machines centrale est un piege mortel. Evitez. J'ai entendu un son comme une cloche de navire sonner a plusieurs reprises depuis les ponts inferieurs. -Rook.",
	"Espanol": "Las luces... parpadearon y se apagaron. Todo quedo en silencio. Senti como si el mundo entier estuviera esperando... Cubierta 4, el acceso a la sala de maquinas central es una trampa mortal. Evitar. Escuche un sonido como el de una campana de barco sonando repetidamente desde las cubiertas inferiores. -Rook."
}

var background_images = [
	preload("res://Assets/Scenarios/FirstFloor/MaintenanceNPC.png")
]

var dialog: Array
var phraseNum: int = 0
var finished: bool = false
var item_manager = null
var is_transitioning: bool = false

# Renamed parameter to 'should_be_visible' to resolve shadowing warning
func toggle_flashlight_visibility(should_be_visible: bool):
	# ASSUMPTION: Flashlight is a global AutoLoad
	if is_instance_valid(Flashlight):
		Flashlight.visible = should_be_visible
	else:
		pass


func _ready():
	# Hide flashlight when dialogue starts
	toggle_flashlight_visibility(false)
	
	# Show cursor when dialogue starts
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	
	choice_box.visible = false

	animator.play("fade_in")
	$Timer.wait_time = textSpeed

	dialog = get_dialog()
	assert(dialog, "Dialog not found at: " + dialogPath)
	
	next_phrase()

func _process(_delta):
	# Check for input only if not currently transitioning
	if not is_transitioning:
		if Input.is_action_just_pressed("Action") \
		or Input.is_action_just_pressed("Action_space") \
		or Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT):

			if finished:
				next_phrase()
			else:
				text_box.visible_characters = len(text_box.text)

# Load the dialogue for the current language
func get_dialog() -> Array:
	var f = FileAccess.open(dialogPath, FileAccess.READ)
	assert(f, "Could not open dialog file at: " + dialogPath)
	
	var json = f.get_as_text()
	var json_object = JSON.new()
	var parse_result = json_object.parse(json)
	
	if parse_result != OK:
		push_error("JSON Parse Error: " + json_object.get_error_message())
		return []
		
	var data = json_object.data

	if typeof(data) == TYPE_DICTIONARY:
		var lang = "English"
		if data.has(lang):
			return data[lang]
		else:
			push_warning("Language '%s' not found in dialogue file, using English fallback." % lang)
			if data.has("English"):
				return data["English"]
			else:
				return []
	else:
		return []

func next_phrase():
	# Check if dialogue is finished (phraseNum == -1 or out of bounds)
	if phraseNum == -1 or phraseNum >= dialog.size():
		end_dialogue()
		return

	finished = false
	var entry = dialog[phraseNum]

	# Clean up previous choices
	choice_box.visible = false
	for child in choice_box.get_children():
		child.queue_free()

	# Set Name and Text
	name_box.bbcode_text = entry["Name"]
	text_box.bbcode_text = entry["Text"]
	text_box.visible_characters = 0

	if entry.has("Background"):
		var index = entry["Background"]
		if index >= 0 and index < background_images.size():
			$TextureRect.texture = background_images[index]

	# Text Typewriter Animation
	while text_box.visible_characters < len(text_box.text):
		text_box.visible_characters += 1
		$Timer.start()
		await $Timer.timeout
	
	if entry.has("Action"):
		var action_parts = entry["Action"].split(":")
		var action_type = action_parts[0]
		var action_value = action_parts[1]
		
		if action_type == "GIVE_ITEM" and action_value == "HollowayNote":
			var current_lang = "English"
			var localized_note = holloway_note_texts.get(current_lang, holloway_note_texts["English"])
			
			# Assuming InventoryManager is a globally accessible singleton (AutoLoad)
			if InventoryManager != null:
				InventoryManager.add_note(localized_note)
				print("Note added to inventory: " + localized_note)
			else:
				push_error("InventoryManager not found. Cannot add item.")
		else:
			print("ACTION TRIGGERED: " + entry["Action"])
	
	# Check for Choices
	if entry.has("Choices"):
		finished = false
		
		var font = Theme.new()
		var font_data = load("res://Assets/Font/Normal.TTF") as FontFile
		font.set_font("font", "Button", font_data)
		font.set_font_size("font_size", "Button", 25)

		for choice in entry["Choices"]:
			var button = Button.new()
			button.text = choice["Text"]
			button.theme = font
			button.connect("pressed", Callable(self, "_on_choice_selected").bind(choice["Next"]))
			choice_box.add_child(button)

		choice_box.visible = true
	else:
		finished = true
		if entry.has("Next"):
			phraseNum = entry["Next"]
		else:
			phraseNum += 1

func _on_choice_selected(next_index: int):
	phraseNum = next_index
	choice_box.visible = false
	for child in choice_box.get_children():
		child.queue_free()
	next_phrase()

func end_dialogue():
	if is_transitioning:
		return
	is_transitioning = true

	if is_instance_valid(GameState):
		GameState.holloway_dialogue_finished = true

	# Only show flashlight and hide cursor if player actually has it
	if InventoryManager.has_item("Flashlight"):
		toggle_flashlight_visibility(true)
		Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)

	# Play NPC Death Sound
	npc_death_sound.play()
	await npc_death_sound.finished

	animator.play("transtion_bedroom") 
	await animator.animation_finished

	# Change to the next scene
	get_tree().change_scene_to_file(nextScenePath)
