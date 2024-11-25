extends Node2D

func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.is_in_group("player") and !settings.debug_mode: #if in debug node, dont kill player
		get_tree().paused = true
		game.emit_signal("player_win")
		print("Player win")
