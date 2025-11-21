extends Node

var navigation_arrows: Array = []
var interaction_arrows: Array = []

func register_arrow(node: Node, arrow_type: String):
	if arrow_type == "navigation":
		navigation_arrows.append(node)
	elif arrow_type == "interaction":
		interaction_arrows.append(node)

func apply_mode(mode: String):
	match mode:
		"immersive":
			_set_visibility(false, false)
		"guided":
			_set_visibility(true, false)
		"complete":
			_set_visibility(true, true)

func _set_visibility(nav_visible: bool, inter_visible: bool):
	for a in navigation_arrows:
		if is_instance_valid(a):
			a.visible = nav_visible

	for a in interaction_arrows:
		if is_instance_valid(a):
			a.visible = inter_visible
