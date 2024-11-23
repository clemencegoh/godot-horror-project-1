extends Node2D

@export var PlayerScene: PackedScene 


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var index = 0
	for i in game.players:
		var currentPlayer = PlayerScene.instantiate()
		currentPlayer.name = str(game.players[i].id)
		add_child(currentPlayer)
		for spawn in get_tree().get_nodes_in_group("PlayerSpawn"):
			if spawn.name == str(index):
				currentPlayer.position = spawn.position
		index += 1


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
