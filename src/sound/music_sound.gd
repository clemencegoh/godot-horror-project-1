extends AudioStreamPlayer

var last_hunt

func _ready():
	game.connect("player_spotted", Callable(self, "player_hunt"))

func player_hunt():
	if !is_playing():
		var array = sound.hunt_sounds
		array.erase(last_hunt) # Sounds werden gelöscht bis keine mehr verfügbar sind --> array leer!
		var sound_stream = array[core.rand_int(0, array.size() - 1)]
		stream = sound_stream
		last_hunt = sound_stream
		play()
