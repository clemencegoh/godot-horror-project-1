extends TextureProgressBar

@onready var BlinkTimer = get_node("BlinkTime")

var BlinkNode

func _ready():
	game.connect("saving_started", Callable(self, "save_data"))
	game.connect("loading_finished", Callable(self, "update_data"))
	
	update_data()
	BlinkTimer.wait_time = game.BLINK_TIME
	#spawn blink rect from software -> self contained
	BlinkNode = ColorRect.new()
	BlinkNode.anchor_bottom = 1
	BlinkNode.anchor_right = 1
	BlinkNode.size_flags_horizontal = SIZE_FILL
	BlinkNode.size_flags_vertical = SIZE_FILL
	BlinkNode.color = Color.BLACK
	BlinkNode.hide()
	get_parent().call_deferred("add_sibling", self, BlinkNode)

func save_data():
	game.player_data["blink"] = value

func update_data(max_v = game.BLINK, cur_v = game.player_data["blink"]):
	max_value = max_v
	value = cur_v

func _physics_process(delta):
	if value == 0 and BlinkTimer.is_stopped():
		blink_once()
	else:
		value -= game.BLINK_RATE

func _unhandled_key_input(event):
	if event.is_action_pressed("blink"): #if player started blinking
		get_viewport().set_input_as_handled()
		BlinkNode.show()
		game.player_data["blinking"] = true
	elif event.is_action_released("blink"): #if player stopped blinking
		get_viewport().set_input_as_handled()
		BlinkTimer.start()

func blink_once():
	BlinkNode.show()
	game.player_data["blinking"] = true
	BlinkTimer.start()

func _on_BlinkTime_timeout():
	BlinkNode.hide()
	game.player_data["blinking"] = false
	value = max_value
