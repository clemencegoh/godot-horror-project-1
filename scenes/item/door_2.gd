extends StaticBody2D

@onready var door_sound = $"./door_use";
@onready var door_open_sprite = $"./DoorOpenSprite"
@onready var door_closed_sprite = $"./DoorClosedSprite"
@onready var door_open_collision = $"./DoorOpenCollision"
@onready var door_closed_collision = $"./DoorClosedCollision"
@onready var door_closed_ocluder = $"./DoorClosedOcluder"

var player_in_range = false
var door_opened = false


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

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
		toggle_door()	

func _on_player_detector_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		player_in_range = true


func _on_player_detector_body_exited(body: Node2D) -> void:
	if body.is_in_group("player"):
		player_in_range = false
