extends Node

var sounds = {
	"Static": "res://Assets/Music/Radio/static.mp3",
	"Song": "res://Assets/Music/Radio/song.mp3",
	"Breath": "res://Assets/Music/Radio/breath.mp3",
	"Phrase": "res://Assets/Music/Radio/music.mp3"
}

@onready var player := AudioStreamPlayer.new()

func _ready():
	randomize()
	add_child(player)
	player.volume_db = -10

func maybe_play_random_sound():
	if not InventoryManager.is_item_picked_up("Radio"):
		return

	var roll = randi_range(1, 10)
	if roll != 1:
		return

	var sound_keys = sounds.keys()
	var random_key = sound_keys[randi_range(0, sound_keys.size() - 1)]
	var sound_path = sounds[random_key]

	var stream := load(sound_path)
	if stream:
		if stream is AudioStream:
			stream.loop = false

		player.stream = stream
		player.play()
