extends Area2D

@export var item_id = "Toolbox"

func _on_body_entered(body):
	if body.name == "Player":
		InventoryManager.add_item(item_id)
		queue_free()
