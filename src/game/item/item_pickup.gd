extends Sprite2D

@export var key_name: String = ''
var player: CharacterBody2D = null

func _ready():
	set_process_unhandled_key_input(false)

func _on_GrabRange_body_entered(body):
	if body.is_in_group("player"):
		player = body
		set_process_unhandled_key_input(true)

func _on_GrabRange_body_exited(body):
	if body.is_in_group("player"):
		set_process_unhandled_key_input(false)

func _unhandled_key_input(event):
	if event.is_action_pressed("interact"):
		get_viewport().set_input_as_handled()
		self.do_item_pickup()
		self.visible = false
				
func do_item_pickup():
	pass
