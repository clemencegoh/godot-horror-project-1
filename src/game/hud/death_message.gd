extends PanelContainer

@onready var parent = get_parent()

func _ready():
	game.connect("player_died", Callable(self, "death"))
	game.connect("loading_finished", Callable(self, "hide"))

func death(killer_name):
	get_node("MessageText").text %= killer_name
	visible = !visible
	
	for child in parent.get_children(): #hide all GUI elements upon death
		if child != self and child.has_method("hide"):
			child.hide()
