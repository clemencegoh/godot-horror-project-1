extends AudioStreamPlayer2D

@onready var MusicTimer = get_node("Timer")

func _on_Timer_timeout(): #play random 017 sound every timeout seconds
	stream = sound.shadow_person[core.rand_int(0,6)]
	play()
	var length = stream.get_length()
	MusicTimer.start(core.rand_float(length, length + 5)) #play next sound in random interval
