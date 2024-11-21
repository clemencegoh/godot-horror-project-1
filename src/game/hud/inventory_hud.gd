extends Control

func _unhandled_key_input(event):
	#show/hide inventory and close it if ESC pressed
	if event.is_action_pressed("inventory") or (visible and event.is_action_pressed("ui_cancel")):
		#get_tree().set_input_as_handled()
		visible = !visible
