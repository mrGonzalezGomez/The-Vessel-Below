extends Node

signal language_changed

var translations = {}
var current_lang = "English"

func _ready():
	# Load translations
	var file = FileAccess.open("res://Languages/Translations/Translations.json", FileAccess.READ)
	if file:
		translations = JSON.parse_string(file.get_as_text())
		file.close()

func set_language(lang: String):
	if lang in translations:
		current_lang = lang
		emit_signal("language_changed")

func t(key: String) -> String:
	# Return translation for current language
	if current_lang in translations and key in translations[current_lang]:
		return translations[current_lang][key]
	return key # fallback if missing
