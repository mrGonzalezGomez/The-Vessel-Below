extends Control

@onready var fade = $Fade
@onready var animator = $AnimationFade
@onready var enter_npc_container = $EnterNPC 
@onready var trans1_button = $EnterNPC/TransNPC
@onready var exit_button = $ExitMaintenance/TransCorridor
@onready var enter1_sprite = $Enter_1
@onready var exit_sprite = $Exit
@onready var background = $MaintenanceBackground


func _ready():
	if is_instance_valid(GameState) and GameState.holloway_dialogue_finished:
		enter_npc_container.queue_free()
		enter1_sprite.queue_free()
	
	animator.play("fade_in")
	
	background.modulate = Color(0.3, 0.3, 0.3, 1.0)

	exit_sprite.modulate = Color(1, 1, 1, 0.2)

	if is_instance_valid(trans1_button):
		# We also check if the sprite is still valid for hover state
		if is_instance_valid(enter1_sprite):
			enter1_sprite.modulate = Color(1, 1, 1, 0.2)
		
		trans1_button.connect("mouse_entered", Callable(self, "_on_trans_npc_hover_start"))
		trans1_button.connect("mouse_exited", Callable(self, "_on_trans_npc_hover_end"))
	
	exit_button.connect("mouse_entered", Callable(self, "_on_trans_corridor_hover_start"))
	exit_button.connect("mouse_exited", Callable(self, "_on_trans_corridor_hover_end"))

func _on_trans_npc_hover_start():
	if is_instance_valid(enter1_sprite):
		enter1_sprite.modulate = Color(1, 1, 1, 0.4)

func _on_trans_npc_hover_end():
	if is_instance_valid(enter1_sprite):
		enter1_sprite.modulate = Color(1, 1, 1, 0.2)

func _on_trans_corridor_hover_start():
	exit_sprite.modulate = Color(1, 1, 1, 0.4)

func _on_trans_corridor_hover_end():
	exit_sprite.modulate = Color(1, 1, 1, 0.2)

func _on_trans_npc_pressed():
	$MetalWalking.play()
	animator.play("transtion_bedroom")
	await animator.animation_finished
	get_tree().change_scene_to_file("res://ScenarioScript/MaintenanceDialogueSS/maintenancedialogue_interface.tscn")

func _on_trans_corridor_pressed():
	$MetalWalking.play()
	animator.play("transtion_bedroom")
	await animator.animation_finished
	get_tree().change_scene_to_file("res://ScenarioScript/CorridorAreaSS/corridor_interface.tscn")
