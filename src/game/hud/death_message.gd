extends PanelContainer

@onready var parent = get_parent()

func _ready():
	game.connect("player_died", Callable(self, "death"))
	game.connect("loading_finished", Callable(self, "hide"))

func death(name):
	self.visible = true
	
	for child in parent.get_children(): # hide all GUI elements upon win
		if child != self and child.has_method("hide"):
			child.hide()
