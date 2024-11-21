extends Camera2D

@export var MAX_ZIN: Vector2 = Vector2(0.3, 0.3)
@export var MAX_ZOUT: Vector2 = Vector2(1.2, 1.2)

func _unhandled_input(event):
	pass
	#if event.is_action_pressed("camera_zin"): # check scroll wheel, camera zoom in and out
		#get_viewport().set_input_as_handled()
		#if zoom > MAX_ZIN:
			#zoom += Vector2(-1,-1) * settings.zoom_res
	#elif event.is_action_pressed("camera_zout"):
		#get_viewport().set_input_as_handled()
		#if zoom < MAX_ZOUT:
			#zoom += Vector2(1,1) * settings.zoom_res
