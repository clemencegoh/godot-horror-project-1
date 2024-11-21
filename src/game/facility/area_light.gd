extends PointLight2D

# This light is only active if the player is in its activation area to save performance
# Light2D is coming at a REALLY heavy performance hit.
# Cannot really use these, unfortunately, until the performance problem has been taken care of.
# At the moment of writing it is expected to be improved with Godot 4.0 and Vulkan :/

func _ready(): #on startup disable
	enabled = false

func _on_ActivationArea_body_entered(body):
	if body.is_in_group("player"):
		enabled = true

func _on_ActivationArea_body_exited(body):
	if body.is_in_group("player"):
		enabled = false
