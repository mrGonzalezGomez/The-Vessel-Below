extends Node

var items: Array[String] = []
var notes: Array[String] = []
var picked_up_items: Array[String] = []
var picked_up_notes: Array[String] = []

func add_item(id: String):
	if not items.has(id):
		items.append(id)
	if not picked_up_items.has(id):
		picked_up_items.append(id)

func add_note(note: String):
	if not notes.has(note):
		notes.append(note)
	if not picked_up_notes.has(note):
		picked_up_notes.append(note)
	if not items.has(note):
		items.append(note)

func has_item(id: String) -> bool:
	return id in items

func is_item_picked_up(id: String) -> bool:
	return id in picked_up_items

func is_note_picked_up(note: String) -> bool:
	return note in picked_up_notes
