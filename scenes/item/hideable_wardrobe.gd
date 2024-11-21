extends StaticBody2D

@onready var door_sound = $"./door_use";
@onready var heartbeat_sound = $"./heartbeat";

var player_in_range = false
var is_hiding = false
var player_object

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_player_detector_body_entered(body: Node2D) -> void:
	if body.name == 'Player':
		player_in_range = true
		player_object = body
	print("player in range of hideable?", player_in_range)


func _on_player_detector_body_exited(body: Node2D) -> void:
	if body.name == 'Player':
		player_in_range = false
		player_object = null
	print("player in range of hideable?", player_in_range)



func _input(event):
	if player_in_range and Input.is_action_just_pressed("interact"):
		door_sound.play()
		
		if !is_hiding:
			player_object.visible = false
			player_object.can_move = false
			await get_tree().create_timer(1).timeout
			heartbeat_sound.play()
			is_hiding = true

		elif is_hiding:
			player_object.visible = true
			player_object.can_move = true
			heartbeat_sound.stop()
			is_hiding = false
