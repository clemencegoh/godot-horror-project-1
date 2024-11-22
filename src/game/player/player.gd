extends CharacterBody2D

@onready var MoveSound = get_node("MoveSound")
@onready var SoundTimer = MoveSound.get_node("Timer")
@onready var SoundPlayer = get_node("SoundEffects")

var inv_visible = false
var can_move = true
var floor_material = ""

func _ready() -> void:
	if self.is_multiplayer_authority():
		var camera = Camera2D.new()
		camera.set_zoom(Vector2(1.8, 1.8))
		self.add_child(camera)

func move(direction):
	var speed
	
	if Input.is_action_pressed("sprint") and !game.player_data["exhausted"] and !game.player_data["flashlight_on"]: #sprint if not exhausted and flashlight not on
		speed = game.SPRINT_SPEED
		move_sound(sound.get("sprint" + floor_material), sound.SPRINT_DELAY) #play sprint sound
	else:
		speed = game.WALK_SPEED
		move_sound(sound.get("walk" + floor_material), sound.WALK_DELAY) #play walk sound
	
	if abs(direction.angle_to(get_global_mouse_position() - position)) > game.WALK_BACK_ANGLE:
		speed *= game.WALK_BACK_FACTOR
	
	set_velocity(direction * speed)
	move_and_slide()
	
func handleMovement(delta):
	if !self.can_move:
		return
	
	velocity = Vector2()
	if Input.is_action_pressed("game_up"): # basic movement
		get_viewport().set_input_as_handled()
		velocity.y -= 1 * delta
	if Input.is_action_pressed("game_down"):
		get_viewport().set_input_as_handled()
		velocity.y += 1 * delta
	if Input.is_action_pressed("game_left"):
		get_viewport().set_input_as_handled()
		velocity.x -= 1 * delta
	if Input.is_action_pressed("game_right"):
		get_viewport().set_input_as_handled()
		velocity.x += 1 * delta
	if velocity.length() != 0:
		move(velocity.normalized())

func handleAnimationChange():
	var y_dir = ''
	var x_dir = ''
	
	if Input.is_action_pressed("game_up"):
		y_dir = 'up'
	if Input.is_action_pressed("game_right"):
		x_dir = 'right'
	if Input.is_action_pressed("game_left"):
		x_dir = 'left'
	if Input.is_action_pressed("game_down"):
		y_dir = 'down'
	if y_dir != '' or x_dir != '':
		$"%PlayerAnimation".play("walk_{y}_{x}".format({'y': y_dir, 'x': x_dir}))
	
# Process per frame
func _process(delta):
	#if $MultiplayerSynchronizer.get_multiplayer_authority() == multiplayer.get_unique_id(): # only move if player is multiplayer authority
		#look_at(get_global_mouse_position()) # rotate head to mouse position
	if is_multiplayer_authority():
		handleMovement(delta)
		handleAnimationChange()

func _unhandled_key_input(event):
	#if event.is_action_pressed("inventory"): #if inventory visible
		#get_viewport().set_input_as_handled()
		#inv_visible = !inv_visible
	if is_multiplayer_authority():
		if Input.is_action_pressed("action2"):
			var newFlashlightValue = !game.player_data["flashlight_on"]
			game.player_data["flashlight_on"] = newFlashlightValue


func move_sound(stream, delay): #sound handling
	if !MoveSound.is_playing() and SoundTimer.is_stopped():
		MoveSound.stream = stream[core.rand_int(0,7)]
		SoundTimer.start(delay)

func _on_Timer_timeout():
	MoveSound.play()

func tease_sound(): #this will play when the player spots an enemy
	if !SoundPlayer.is_playing():
		SoundPlayer.stream = sound.spot_sounds[core.rand_int(0,2)]
		SoundPlayer.play()

func scare_sound(): #this will play when the player gets "jump-scared"
	if !SoundPlayer.is_playing():
		SoundPlayer.stream = sound.scare_sounds[core.rand_int(0,3)]
		SoundPlayer.play()

####### Multiplayer stuff #######
func _enter_tree() -> void:
	set_multiplayer_authority(name.to_int())

		
