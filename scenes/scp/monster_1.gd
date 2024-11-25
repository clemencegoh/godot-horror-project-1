extends CharacterBody2D

var movement_speed = 50.0
@export var target: Node2D = null

@onready var navigation_agent_2d = $NavigationAgent2D
@onready var animation_player: AnimationPlayer = $"./MonsterModel/AnimationPlayer"

var caught_in_flashlight = false
var acquiring_target = false

# Called when the node enters the scene tree for the first time.
func _ready():
	animation_player.play("monster_idle")
	call_deferred("seeker_setup")
	game.connect("monster_spotted_in_flashlight", Callable(self, "monster_freeze"))
	game.connect("monster_not_in_flashlight", Callable(self, "monster_unfreeze"))
	game.connect("player_spotted", Callable(self, "should_acquire_target"))
	#pass # Replace with function body.
#
func seeker_setup():
	await get_tree().physics_frame
	if target:
		navigation_agent_2d.target_position = target.global_position
		print(target.global_position)

func should_acquire_target():
	acquiring_target = true
		
func acquire_target():
	var players_around = get_tree().get_nodes_in_group("player")
	
	if len(players_around) > 0:
		var new_target = players_around[0]
		target = new_target

func monster_freeze():
	self.caught_in_flashlight = true
func monster_unfreeze():
	self.caught_in_flashlight = false
#
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	if is_instance_valid(target):
		navigation_agent_2d.target_position = target.global_position
	else:
		if acquiring_target:
			acquire_target()
	if navigation_agent_2d.is_navigation_finished():
		return
		
	var current_agent_position = global_position
	var next_path_position = navigation_agent_2d.get_next_path_position()
	var new_velocity = current_agent_position.direction_to(next_path_position) * movement_speed
	
	if navigation_agent_2d.avoidance_enabled:
		navigation_agent_2d.set_velocity(new_velocity)
	else:
		_on_navigation_agent_2d_velocity_computed(new_velocity)
	
	if !caught_in_flashlight:
		move_and_slide()


func _on_navigation_agent_2d_velocity_computed(safe_velocity):
	velocity = safe_velocity
	pass # Replace with function body.
	
