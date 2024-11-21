extends AudioStreamPlayer

@onready var menu_theme = preload("res://music/menu/menu_music_box.ogg")

func loop_theme():
	stream = menu_theme
	play()
