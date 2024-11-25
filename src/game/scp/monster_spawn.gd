extends Node2D

@export var spawn_timer: int
@export var monster: PackedScene
@onready var summoning_circle = $"./Sprite2D"


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	await get_tree().create_timer(spawn_timer).timeout
	self.add_child(monster.instantiate())
	self.summoning_circle.visible = false
	
