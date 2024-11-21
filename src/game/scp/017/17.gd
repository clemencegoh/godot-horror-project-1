extends CharacterBody2D

@onready var Nav = get_tree().get_root().find_child("Navigation", true, false)
@onready var Pathfinding = get_node("DebugPathfinding")
@onready var IdleTimer = get_node("IdleTimer")
@onready var Raycast = get_node("RayCastTarget")
@onready var cs_radius = get_node("CollisionShape3D").shape.radius #collision shape radius

@export var MOVE_SPEED: float = 90
@export var STUCK_THRES: float = .01
@export var IDLE_SPEED: float = 40
@export var IDLE_DISTANCE: float = 120
@export var IDLE_TIME_MIN = 4 # (float, 1, 60)
@export var IDLE_TIME_MAX = 12 # (float, 1, 60)

var speed = MOVE_SPEED #current moving speed
var path = PackedVector2Array()

func create_path(pos):
	path = Nav.get_path_to(pos)
	#look_at(pos)

func move(s = MOVE_SPEED):
	var distance = path[0] - position
	
	while distance.length() <= cs_radius + .1: #loop through until valid target pos has been found
		path.remove(0)
		if path.size() == 0:
			return
		distance = path[0] - position
	
	set_velocity(distance.normalized() * s)
	move_and_slide()
	#look_at(distance)

func open_door(door): #this function will probably kill everybody
	door.door_control()
	print("FBI, open up!")

func _physics_process(delta):
	if Raycast.TargetNode != null: #if target found then stop idle movement and follow target
		IdleTimer.stop()
		speed = MOVE_SPEED
		create_path(Raycast.TargetNode.position)
	
	if path.size() != 0:
		move(speed)
		for i in get_slide_collision_count():
			var collision = get_slide_collision(i)
			var Collider = collision.collider
			if Collider.is_in_group("door") and Collider.door_clearance == 0:
				open_door(Collider)
			elif collision.travel.length() <= STUCK_THRES: #this prevents the scp to get indefinitely stuck
				path.resize(0)
	elif IdleTimer.is_stopped(): #if no path to go start idle movement
		IdleTimer.start(core.rand_int(IDLE_TIME_MIN,IDLE_TIME_MAX))
	
	# DEBUG STUFF #
	if settings.debug_mode: #if in debug mode then show the Pathfinding vectors
		var debug_path = PackedVector2Array()
		for i in path:
			debug_path.append(to_local(i))
		Pathfinding.points = debug_path

func _on_IdleTimer_timeout(): #crude idle movement implementation
	var idle_target = Vector2()
	idle_target.x = core.rand_int(-IDLE_DISTANCE, IDLE_DISTANCE)
	idle_target.y = core.rand_int(-IDLE_DISTANCE, IDLE_DISTANCE)
	speed = IDLE_SPEED
	create_path(position + idle_target)

func save():
	var save_dict = {
					"MOVE_SPEED": MOVE_SPEED,
					"STUCK_THRES": STUCK_THRES,
					"IDLE_SPEED": IDLE_SPEED,
					"IDLE_DISTANCE": IDLE_DISTANCE,
					"IDLE_TIME_MIN": IDLE_TIME_MIN,
					"IDLE_TIME_MAX": IDLE_TIME_MAX,
					"speed": speed,
					"path": var_to_str(path)
					}
	return save_dict
