extends Control

@onready var fade = $Fade
@onready var animator = $AnimationFade
@onready var bg = $CreatureBackground
@onready var creature_image = preload("res://Assets/Scenarios/GroundFloor/CreatureRoom.png")
@onready var interface_image = preload("res://Assets/Scenarios/GroundFloor/CreatureTransition.png")
@onready var qte_image = preload("res://Assets/Scenarios/GroundFloor/QteScenario.png")
@onready var scream = $Scream

func _ready() -> void:
	animator.play("fade_in")
	play_creature_jump_sequence()

func play_creature_jump_sequence() -> void:

	# STEP 1 — show creature
	bg.texture = creature_image
	await get_tree().create_timer(2).timeout

	# STEP 2 — switch to interface background
	bg.texture = interface_image
	if scream:
		scream.play()
	set_process(false)
	await get_tree().create_timer(0.5).timeout

	# STEP 3 — switch to QTE background (final jump)
	bg.texture = qte_image
	
	# STEP 4 — START QTE
	start_qte()

func start_qte():
	var qte_scene := preload("res://ScenarioScript/QteSS/qte_interface.tscn")
	var qte := qte_scene.instantiate()

	# Pass flags
	qte.flag_valve = GameState.valve_on
	qte.flag_cord = GameState.cord_on
	add_child(qte)
