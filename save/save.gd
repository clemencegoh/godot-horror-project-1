extends Node

const SAVEGAME = 'user://Savegame.json'

var save_data = {}

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	save_data = get_data()
	
func get_data():
	if not FileAccess.file_exists(SAVEGAME):
		save_data = {"Player_name": "Unnamed"}
		save_game()
	
	var file = FileAccess.open(SAVEGAME, FileAccess.READ)
	var content = file.get_as_text()
	var data = JSON.parse_string(content)
	save_data = data
	file.close()
	return data

func save_game():
	var save_game = FileAccess.open(SAVEGAME, FileAccess.WRITE)
	save_game.store_line(JSON.stringify(save_data))


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
