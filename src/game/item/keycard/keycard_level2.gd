extends "res://src/game/item/item_pickup.gd"

@export var item_name = "Level 2 Keycard" # (String, MULTILINE)
@export var item_description = "A Level 2 security keycard. Can be used to open security doors." # (String, MULTILINE)
@export var has_clearance: bool = true
@export var item_clearance = 2 # (int, 10)

func save():
	var dict = {
				"item_dict": {
							"item_name": item_name,
							"item_description": item_description,
							"has_clearance": has_clearance,
							"item_clearance": item_clearance
							}
				}
	return dict
