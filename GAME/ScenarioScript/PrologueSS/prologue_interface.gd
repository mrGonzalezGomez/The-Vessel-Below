extends Control

@export var dialogPath = "res://Assets/Dialogue/JsonFiles/Prologue/PrologueDialogue.json"
@export var textSpeed = 0.05

@onready var fade = $Fade
@onready var animator = $AnimationFade
@onready var audio_player = $DialogueAudioPlayer

var background_images = [
	preload("res://Assets/Scenarios/Prologue/PrologueScene1.png"),
	preload("res://Assets/Scenarios/Prologue/PrologueScene2.png"),
	preload("res://Assets/Scenarios/Prologue/PrologueScene3.png")
]

var dialog: Array
var phraseNum: int = 0
var finished: bool = false

func _ready():
	animator.play("fade_in")
	$Timer.wait_time = textSpeed
	dialog = getDialog()
	assert(dialog, "Dialog not found!")
	nextPhrase()

func _process(_delta):
	if Input.is_action_just_pressed("Action") \
	or Input.is_action_just_pressed("Action_space") \
	or Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT):

		if finished:
			nextPhrase()
		else:
			$DialogueBox/TextBox.visible_characters = len($DialogueBox/TextBox.text)

func getDialog() -> Array:
	var f = FileAccess.open(dialogPath, FileAccess.READ)
	assert(f, "Could not open dialog file!")
	var json = f.get_as_text()
	var json_object = JSON.new()
	json_object.parse(json)
	var data = json_object.data

	if typeof(data) == TYPE_DICTIONARY:
		var lang = LanguageManager.current_lang
		if data.has(lang):
			return data[lang]
		elif data.has("English"):
			push_warning("Language missing, using English fallback.")
			return data["English"]
		else:
			return []
	elif typeof(data) == TYPE_ARRAY:
		return data
	else:
		return []

func nextPhrase():
	if phraseNum >= dialog.size():
		get_tree().change_scene_to_file("res://ScenarioScript/BedroomAreaSS/bedroom_interface.tscn")
		return

	finished = false
	var entry = dialog[phraseNum]

	### AUDIO: Stop any previous clip ###
	audio_player.stop()  ### ADDED FOR AUDIO ###

	$ChoiceBox.visible = false
	for child in $ChoiceBox.get_children():
		child.queue_free()

	$DialogueBox/NameBox.bbcode_text = entry["Name"]
	$DialogueBox/TextBox.bbcode_text = entry["Text"]
	$DialogueBox/TextBox.visible_characters = 0

	# Background logic unchanged
	if entry.has("Background"):
		var index = entry["Background"]
		if index >= 0 and index < background_images.size():
			$PrologueBackground.texture = background_images[index]

		if index == 2:
			if not $AlarmSound.playing:
				$AlarmSound.play()
		else:
			$AlarmSound.stop()

		var blackout_texts = [
			"*Your vision blurs. Porter screams. Something slams the hull. Darkness.*",
			"*Votre vision se trouble. Porter crie. Quelque chose percute la coque. Obscurite.*",
			"*Tu vision se nubla. Porter grita. Algo golpea el casco. Oscuridad.*"
		]

		if entry["Text"] in blackout_texts:
			$ExplosionSound.play()
			$AnimationFade.play("blackout")

	### AUDIO: Play voice for this line ###
	if entry.has("Audio"):                                   ### ADDED FOR AUDIO ###
		var audio_path = entry["Audio"]
		if ResourceLoader.exists(audio_path):
			var stream = load(audio_path)
			if stream:
				audio_player.stream = stream
				audio_player.play()                           ### ADDED FOR AUDIO ###
		else:
			push_warning("Audio file not found: " + audio_path) ### ADDED FOR AUDIO ###

	### TEXT TYPEWRITER ###
	while $DialogueBox/TextBox.visible_characters < len($DialogueBox/TextBox.text):
		$DialogueBox/TextBox.visible_characters += 1
		$Timer.start()
		await $Timer.timeout

	### CHOICES ###
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
			$ChoiceBox.add_child(button)

		$ChoiceBox.visible = true
	else:
		finished = true
		if entry.has("Next"):
			phraseNum = entry["Next"]
		else:
			phraseNum += 1

func _on_choice_selected(next_index: int):
	phraseNum = next_index
	$ChoiceBox.visible = false
	for child in $ChoiceBox.get_children():
		child.queue_free()
	nextPhrase()
