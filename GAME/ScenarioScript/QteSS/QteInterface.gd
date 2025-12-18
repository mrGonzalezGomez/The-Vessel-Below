extends Control

@onready var key_label = $KeyLabel
@onready var progress_circle = $ProgressCircle

# Flags from Valve room
var flag_valve := false
var flag_cord := false

# Flags for GTE
var required_key := ""
var key_hits := 0
var required_hits := 10
var qte_finished := false
const FORBIDDEN_KEYS = ["I"]

func _ready() -> void:
	setup_difficulty()
	generate_new_key()
	progress_circle.value = 0

func setup_difficulty() -> void:
	var score := int(flag_valve) + int(flag_cord)

	match score:
		2:  # EASY
			required_hits = randi_range(10, 15)
		1:  # MEDIUM
			required_hits = randi_range(15, 20)
		0:  # HARD
			required_hits = randi_range(25, 30)

func generate_new_key() -> void:
	var key := ""
	while key == "" or key in FORBIDDEN_KEYS:
		key = char(randi_range(ord("A"), ord("Z")))

	required_key = key
	key_label.text = required_key

func _input(event: InputEvent) -> void:
	if event is InputEventKey and event.pressed:
		var pressed_key := OS.get_keycode_string(event.keycode).to_upper()

		if pressed_key == required_key:
			key_hits += 1
			update_progress()

			if key_hits >= required_hits:
				qte_success()
			else:
				generate_new_key()
		else:
			qte_wrong_key()

	if qte_finished:
		return

func update_progress() -> void:
	var percent := float(key_hits) / float(required_hits) * 100.0
	progress_circle.value = percent

func qte_success():
	qte_finished = true
	print("QTE SUCCESS!")
	get_tree().change_scene_to_file("res://ScenarioScript/BigMotorSS/big_interface.tscn")

func qte_wrong_key() -> void:
	# Determine difficulty
	var score := int(flag_valve) + int(flag_cord)

	var penalty := 0
	match score:
		2:  # EASY
			penalty = 0
		1:  # MEDIUM
			penalty = 2
		0:  # HARD
			penalty = 3

	key_hits = max(key_hits - penalty, 0)
	update_progress()
