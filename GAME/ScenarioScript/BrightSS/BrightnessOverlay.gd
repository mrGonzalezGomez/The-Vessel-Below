extends CanvasLayer

@onready var overlay: ColorRect = $ColorRect
var brightness_level: float = 0.0 # range -40 to 0

func _ready():
	# Allow clicks to pass through the overlay
	overlay.mouse_filter = Control.MOUSE_FILTER_IGNORE

func set_brightness(value: float):
	brightness_level = value
	# Convert slider range (-40 → 0) into opacity (0.6 → 0)
	var alpha = clamp((abs(value) / 40.0) * 0.6, 0.0, 0.6)
	overlay.color = Color(0, 0, 0, alpha)
