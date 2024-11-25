extends "res://src/game/item/item_pickup.gd"

@onready var pickup_sound: AudioStreamPlayer2D = $"./PickupSound"

func do_item_pickup():
	var keyObject = Node2D.new()
	keyObject.name = key_name
	player.get_node("./Inventory").add_child(keyObject)
	pickup_sound.play()
	self.visible = false
