extends Node

var items: Array[String] = []
var notes: Array[String] = []

func add_item(id: String):
	if not items.has(id):
		items.append(id)

func add_note(note: String):
	if not notes.has(note):
		notes.append(note)

func has_item(id: String) -> bool:
	return id in items
