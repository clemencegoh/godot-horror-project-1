extends PanelContainer

@onready var parent = get_parent()

func _ready():
	game.connect("player_win", Callable(self, "win"))
	game.connect("loading_finished", Callable(self, "hide"))

func win(name):
	visible = !visible
	
	for child in parent.get_children(): # hide all GUI elements upon win
		if child != self and child.has_method("hide"):
			child.hide()
