extends PanelContainer

@onready var timer = get_node("Timer")

func _ready():
	game.connect("loading_started", Callable(self, "loading"))
	game.connect("loading_finished", Callable(self, "launch_timer"))

func loading():
	visible = true

func launch_timer():
	timer.start()

func _on_Timer_timeout():
	visible = false