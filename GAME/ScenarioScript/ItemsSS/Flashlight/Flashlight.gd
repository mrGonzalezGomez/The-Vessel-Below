extends CanvasLayer

@onready var light = $PointLight2D

func _ready():
	# Hide light unless player has the flashlight
	light.visible = InventoryManager.is_item_picked_up("Flashlight")

func _process(_delta):
	if not light.visible:
		return

	# Make flashlight follow the cursor
	light.global_position = get_viewport().get_mouse_position()
