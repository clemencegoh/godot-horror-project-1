extends StaticBody2D

@export var gate_partner_path: NodePath
@export var door_open: bool = false #is this door open? Mostly used for loading and the dual door gate
@export var door_clearance = 0 #no clearance needed, keycard needed for >0 # (int, 10)

@onready var DoorSprite = get_node("DoorModel")
@onready var Anim = DoorSprite.get_node("DoorAnimation")
@onready var DoorSound = get_node("DoorSound")
@onready var KeySound = get_node("KeycardSound")

var gate_partner #onready var gate_partner = get_node(gate_partner_path)
var door_animation = "door_anim" #the right door_anim for this door

func _ready():
	set_process_unhandled_key_input(false)
	get_node("LightOccluderLeft").occluder = get_node("LightOccluderLeft").occluder.duplicate() #make unique
	get_node("LightOccluderRight").occluder = get_node("LightOccluderRight").occluder.duplicate()
	get_node("CollisionShape2D").shape = get_node("CollisionShape2D").shape.duplicate()
	get_node("CollisionShape2").shape = get_node("CollisionShape2").shape.duplicate()
	game.connect("loading_finished", Callable(self, "init_door"))
	
	init_door()

func init_door():
	if !NodePath(gate_partner_path).is_empty():
		gate_partner = get_node(gate_partner_path)
	
	if door_clearance > 0: #initiate the right door sprites
		door_animation = "secure_door_anim"
	
	Anim.play(door_animation)
	
	if door_open: #open door
		Anim.seek(0, true)
	else: #close door
		Anim.seek(Anim.current_animation_length, true)
	
	Anim.stop()

func check_clearance(): #query clearance level from inventory
	if door_clearance == 0: #check if door is open for everyone
		return true
	
	for key in inventory.inventory.keys():
		if inventory.inventory[key]["item_clearance"] >= door_clearance:
			KeySound.stream = sound.keycard_use[0] #if adequate play OK sound
			KeySound.play(.4)
			return true
	
	return false

func door_error(): #security clearance not adequate
	Anim.play("door_error")

func door_control():
	if !Anim.is_playing():
		if DoorSprite.frame == 0: #closed
			Anim.play_backwards(door_animation)
			DoorSound.stream = sound.door_open[core.rand_int(0,2)]
		else: #opened
			Anim.play(door_animation)
			DoorSound.stream = sound.door_close[core.rand_int(0,2)]
			
		DoorSound.play(.3)
		door_open = !door_open
		
		if gate_partner != null: #this controls the interlocking security gate function
			gate_partner.door_control()

func _unhandled_key_input(event):
	if event.is_action_pressed("interact"):
		get_viewport().set_input_as_handled()
		if Anim.is_playing():
			return
		
		if check_clearance(): #check door for adequate clearance
			door_control()
		else:
			door_error()

func _on_InteractionArea_body_entered(body):
	if body.is_in_group("player"):
		set_process_unhandled_key_input(true)

func _on_InteractionArea_body_exited(body):
	if body.is_in_group("player"):
		set_process_unhandled_key_input(false)

func save():
	var save_dict = {
					"gate_partner_path": gate_partner_path,
					"door_clearance": door_clearance,
					"door_open": door_open
					}
	return save_dict
