extends TextureRect

@onready var item_name_label = $ItemImage/ItemName

func _ready():
	if has_node("ItemImage"):
		$ItemImage.expand = true
		$ItemImage.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED

	if not item_name_label:
		push_error("ItemName node not found in ItemSlot!")

func set_item(item_name: String):
	var texture_path: String
	
	if item_name == "Flashlight":
		texture_path = "res://Assets/Items/%s.png" % item_name
	elif item_name == "The lights... they flickered and died. Everything went silent. I felt like the whole world was waiting... Deck 4, Central Engine Room Access is a death trap. Avoid. Heard a sound like a ship's bell chiming repeatedly from the lower decks. -Rook.":
		texture_path = "res://Assets/Items/Bloody.png"
	else:
		texture_path = "res://Assets/Items/PaperNote.png"

	if ResourceLoader.exists(texture_path):
		$ItemImage.texture = load(texture_path)
	else:
		var alt_path = "res://Assets/Items/%s.png" % item_name.to_lower()
		if item_name != "Flashlight" and ResourceLoader.exists("res://Assets/Items/papernote.png"):
			$ItemImage.texture = load("res://Assets/Items/papernote.png")
		elif ResourceLoader.exists(alt_path):
			$ItemImage.texture = load(alt_path)
		else:
			push_warning("Texture not found: %s" % texture_path)
			$ItemImage.texture = null

	if item_name_label:
		if item_name == "Flashlight":
			item_name_label.text = item_name
		else:
			item_name_label.text = "Journal Page"
		item_name_label.visible = false


func _on_mouse_entered():
	if item_name_label:
		item_name_label.visible = true

func _on_mouse_exited():
	if item_name_label:
		item_name_label.visible = false
