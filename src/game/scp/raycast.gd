extends RayCast2D

var AreaTarget
var TargetNode

func _on_RayCastArea_body_entered(body):
	if body.is_in_group("player"):
		AreaTarget = body
		enabled = true

func _on_RayCastArea_body_exited(body):
	if body.is_in_group("player"):
		TargetNode = null
		enabled = false

func _physics_process(delta):
	if enabled:
		#target_position = to_local(AreaTarget.position)
		#
		#if get_collider() == AreaTarget: #if enemy sees target
			#TargetNode = AreaTarget
			#game.emit_signal("player_spotted") #mark player as spotted
		#else:
			#TargetNode = null
		
		queue_redraw()

func _draw():
	if settings.debug_mode: #if in debug mode, draw TargetNode
		draw_circle(target_position, 5, Color(1,0,0,1))
