extends TextureProgressBar

@onready var normal_color = texture_progress.gradient
@export var flashlight_sound: AudioStreamPlayer2D

var is_sound_playing = false

func _ready():
	game.connect("saving_started", Callable(self, "save_data"))
	game.connect("loading_finished", Callable(self, "update_data"))
	
	flashlight_sound.finished.connect(signal_finished)
	
	update_data()

func save_data():
	game.player_data["flashlight"] = value

func update_data(max_v = game.STAMINA, cur_v = game.player_data["flashlight"]):
	max_value = max_v
	value = cur_v
	
func signal_finished():
	is_sound_playing = false

func play_flashlight_sound():
	if is_sound_playing:
		return
	flashlight_sound.play()
	is_sound_playing = true

func _physics_process(delta):
	if value == 0: # turn off flashlight, require recharge
		game.player_data["flashlight_on"] = false
	
	if game.player_data["flashlight_on"]:
		value -= game.FLASHLIGHT_EXHAUST
	
	if Input.is_action_pressed("interact") and is_multiplayer_authority() and !game.player_data["flashlight_on"]:
		value += game.FLASHLIGHT_RECHARGE_SPEED
		play_flashlight_sound()
