extends PointLight2D

var monster_in_area = false


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if is_multiplayer_authority():
		look_at(get_global_mouse_position()) # rotate to mouse position
		
	self.visible = game.player_data['flashlight_on']



func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.is_in_group("monster"):
		monster_in_area = true
		if self.visible:
			game.emit_signal("monster_spotted_in_flashlight")


func _on_area_2d_body_exited(body: Node2D) -> void:
	if body.is_in_group("monster"):
		monster_in_area = false
		game.emit_signal("monster_not_in_flashlight")


func _on_visibility_changed() -> void:
	if !self.visible:
		game.emit_signal("monster_not_in_flashlight")
	if self.visible and monster_in_area:
		game.emit_signal("monster_spotted_in_flashlight")
