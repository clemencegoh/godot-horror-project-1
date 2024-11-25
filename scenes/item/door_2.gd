extends StaticBody2D

@export var door_key_name: String = ""
@onready var door_sound = $"./door_use";
@onready var door_open_sprite = $"./DoorOpenSprite"
@onready var door_closed_sprite = $"./DoorClosedSprite"
@onready var door_open_collision = $"./DoorOpenCollision"
@onready var door_closed_collision = $"./DoorClosedCollision"
@onready var door_closed_ocluder = $"./DoorClosedOcluder"
@onready var door_locked_sprite = $"./DoorLockedSprite"
@onready var door_open_label = $"./EToOpen"

var player_in_range = false
var player_keys = []
var door_opened = false

func _ready():
	if door_key_name == "":
		self.door_locked_sprite.visible = false
		

func toggle_door():
	var new_door_opened = !door_opened
	
	door_open_sprite.visible = new_door_opened == true
	door_open_collision.disabled = new_door_opened == false
	
	door_closed_collision.disabled = new_door_opened == true
	door_closed_sprite.visible = new_door_opened == false
	
	door_closed_ocluder.visible = new_door_opened == false
	
	door_opened = new_door_opened

func _input(event):
	if player_in_range and Input.is_action_just_pressed("interact"):
		door_sound.play()
		if !self.door_locked_sprite.visible:
			toggle_door()
		

func get_node_name(item: Node2D):
	return item.name

func _on_player_detector_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		player_in_range = true
		player_keys = body.get_node("./Inventory").get_children().map(get_node_name)
		if player_keys.has(door_key_name):
			self.door_locked_sprite.visible = false
			self.door_open_label.visible = true

func _on_player_detector_body_exited(body: Node2D) -> void:
	if body.is_in_group("player"):
		player_in_range = false
	self.door_open_label.visible = false
