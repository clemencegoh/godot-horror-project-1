extends Label

func _on_Timer_timeout():
	text = str(Performance.get_monitor(Performance.TIME_FPS))
