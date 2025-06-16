extends Area2D

@export var note_text = "Page from the captain's log..."

func _on_body_entered(body):
	if body.name == "Player":
		InventoryManager.add_note(note_text)
		queue_free()
