extends Button

func _on_QuitButton_pressed():
	get_tree().change_scene_to_file("res://scenes/main_menu.tscn")
	get_tree().paused = false