extends Button

@onready var menu = get_parent().get_parent()

func _on_ResumeButton_pressed():
	menu.visible = false
	get_tree().paused = false
