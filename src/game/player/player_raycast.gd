extends RayCast2D

# MIGHT BE BUGGY, QUITE COMPLICATED AND PRETTY EXPENSIVE, I GUESS.
# MORE TESTING REQUIRED!

signal danger_spotted
signal danger_scared

var spot_targets = []
var scare_targets = []

var prev_scare = []
var prev_spot = []

func accept_body(body):
	if body.is_class("CharacterBody2D") and body != get_parent():
		return true
	else:
		return false

func check_disable():
	if scare_targets.size() == 0 and spot_targets.size() == 0:
		return false
	else:
		return true

func _on_ScareArea_body_entered(body):
	if accept_body(body):
		scare_targets.append(body)
		enabled = true

func _on_ScareArea_body_exited(body):
	if accept_body(body):
		scare_targets.erase(body)
		if prev_scare.has(body):
			prev_scare.erase(body)
		
		enabled = check_disable()

func _on_SpotArea_body_entered(body):
	if accept_body(body):
		spot_targets.append(body)
		enabled = true

func _on_SpotArea_body_exited(body):
	if accept_body(body):
		spot_targets.erase(body)
		if prev_spot.has(body):
			prev_spot.erase(body)
		
		enabled = check_disable()

func _physics_process(delta):
	if enabled:
		for body in spot_targets:
			target_position = to_local(body.position)
			force_raycast_update()
			
			if get_collider() == body and !prev_scare.has(body) and !prev_spot.has(body):
				if scare_targets.has(body):
					emit_signal("danger_scared")
					prev_scare.append(body)
				else:
					emit_signal("danger_spotted")
					prev_spot.append(body)
