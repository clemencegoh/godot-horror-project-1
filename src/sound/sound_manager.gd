extends Node

#delay between steps in ms
const WALK_DELAY = .02
const SPRINT_DELAY = 0

# PLAYER
var walk = []
var sprint = []
var walk_metal = []
var sprint_metal = []
var keycard_use = []
var item_pickup = []
var item_drop = []
# ENEMY SPOTTED SOUND
var spot_sounds = []
var scare_sounds = []
# ENEMY HUNT SOUNDS
var hunt_sounds = []
# DOORS
var door_open = []
var door_close = []
# DEATH AND DAMAGE
var death_sounds = {}
# SCPs
var shadow_person = []
var the_sculpture = []

func _ready():
	walk = load_stream("step/walk/step")
	walk_metal = load_stream("step/walk/step_metal")
	sprint = load_stream("step/sprint/sprint")
	sprint_metal = load_stream("step/sprint/sprint_metal")
	keycard_use = load_stream("interact/keycard_use", 2)
	door_open = load_stream("facility/door/door_open", 3)
	door_close = load_stream("facility/door/door_close", 3)
	shadow_person = load_stream("scp/017/idle", 7)
	the_sculpture = load_stream("scp/173/rattle", 3)
	item_pickup = load_stream("interact/pick_item", 1)
	scare_sounds = load_stream("horror/near_death/horror", 4)
	spot_sounds = load_stream("horror/spot/horror", 3)
	item_drop = load_stream("interact/drop_item", 1)
	hunt_sounds = load_stream("horror/hunt/hunt", 4)
	
	load_death_sounds()

func load_stream(dir, m = 8): # Search for correct sound files
	var array = []
	
	for i in range(1,m+1):
		var path = "res://sounds/" + dir + str(i) + ".ogg"
		if FileAccess.file_exists(path + ".import"): #searching for *.import files fixes export paths
			array.append(load(path))
	
	return array

func load_death_sounds(): #array name must be the same as scene name!
	death_sounds["SCP-173"] = load_stream("scp/173/neck_snap", 3)
	death_sounds["SCP-017"] = load_stream("scp/017/catch", 1)
