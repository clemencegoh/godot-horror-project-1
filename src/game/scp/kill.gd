extends Area2D

func _on_KillArea_body_entered(body):
	if body.is_in_group("player") and !settings.debug_mode: #if in debug node, dont kill player
		inventory.inventory.clear() #delete inventory
		
		get_tree().paused = true
		
		game.emit_signal("player_died", get_parent().name)
