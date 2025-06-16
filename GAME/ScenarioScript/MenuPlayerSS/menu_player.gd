extends AudioStreamPlayer

var allowed_scenes = ["menu_interface", "options_interface"]
var last_scene_name = ""

func _ready():
	_check_scene(get_tree().current_scene)

func _process(_delta):
	var current_scene = get_tree().current_scene
	if current_scene:
		var scene_name = current_scene.scene_file_path.get_file().get_basename()
		if scene_name != last_scene_name:
			last_scene_name = scene_name
			_check_scene(current_scene)

func _check_scene(new_scene):
	var scene_name = new_scene.scene_file_path.get_file().get_basename()
	if scene_name in allowed_scenes:
		if not playing:
			play()
	else:
		stop()
