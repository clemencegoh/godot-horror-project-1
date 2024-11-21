extends PanelContainer

func _unhandled_key_input(event):
	if event.is_action_pressed("ui_cancel"):
		get_viewport().set_input_as_handled()
		visible = !visible
		get_tree().paused = visible
