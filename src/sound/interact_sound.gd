extends AudioStreamPlayer

func _ready():
	inventory.connect("item_grabbed", Callable(self, "grab_item"))
	inventory.connect("item_dropped", Callable(self, "drop_item"))
	game.connect("player_died", Callable(self, "player_death"))

func player_death(killer_name):
	var array = sound.death_sounds[killer_name]
	stream = array[core.rand_int(0,array.size()-1)]
	play()

func grab_item(): #this sound plays when the player picks up an item
	stream = sound.item_pickup[0]
	play()

func drop_item():
	stream = sound.item_drop[0]
	play()
