extends CanvasLayer

@onready var light: PointLight2D = $PointLight2D
@onready var dot: PointLight2D = $PointLight2D2

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

func _process(_delta):
	if not light.visible: return
	
	# Make flashlight follow the cursor
	var mouse_pos = get_viewport().get_mouse_position()
	light.global_position = mouse_pos
	dot.global_position = mouse_pos
