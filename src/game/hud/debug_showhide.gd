extends Node2D

var toggle = false

#this just toggles visibility for all nodes attached with this script upon entering debug_mode.
func _process(delta):
	if toggle != settings.debug_mode:
		visible = !visible
		toggle = settings.debug_mode
