extends TextureRect

@onready var item_name_label = $ItemImage/ItemName

func _ready():
	if has_node("ItemImage"):
		$ItemImage.expand = true
		$ItemImage.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED

	if not item_name_label:
		push_error("ItemName node not found in ItemSlot!")

func set_item(item_name: String):
	var texture_path = "res://Assets/Items/%s.png" % item_name

	if ResourceLoader.exists(texture_path):
		$ItemImage.texture = load(texture_path)
	else:
		var alt_path = "res://Assets/Items/%s.png" % item_name.to_lower()
		if ResourceLoader.exists(alt_path):
			$ItemImage.texture = load(alt_path)
		else:
			push_warning("Texture not found: %s or %s" % [texture_path, alt_path])
			$ItemImage.texture = null

	if item_name_label:
		item_name_label.text = item_name
		item_name_label.visible = false

func _on_mouse_entered():
	if item_name_label:
		item_name_label.visible = true

func _on_mouse_exited():
	if item_name_label:
		item_name_label.visible = false
