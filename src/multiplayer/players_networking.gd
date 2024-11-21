extends Node

# So far this script manages position and rotation of any player over an unlimited number of clients.
# + it shows all clients their ping

var SERVER_PORT = 9090
var SERVER_IP = "127.0.0.1"
var MAX_CLIENTS = 2

var peer = ENetMultiplayerPeer.new()
var players = {}

var positions = {}
var rotations = {}

@onready var main_node = self#get_tree().get_root().get_node("World")
@onready var player = main_node.get_node("Player")
@onready var ping_display = main_node.get_node("HUD/PingDisplay")

var t_time #used for ping computation

func init_server():
	peer.create_server(SERVER_PORT, MAX_CLIENTS)
	get_tree().set_multiplayer_peer(peer)
	
	player.name = "1"
	positions[1] = player.position
	rotations[1] = player.rotation
	players[1] = player
	
	peer.connect("peer_connected", Callable(self, "client_connect"))
	peer.connect("peer_disconnected", Callable(self, "client_disconnect"))
	#peer.compression_mode = NetworkedMultiplayerENet.COMPRESS_FASTLZ

func kill_connection():
	peer.close_connection()
	get_tree().set_multiplayer_peer(null)
	#peer.compression_mode = NetworkedMultiplayerENet.COMPRESS_FASTLZ

func _on_ServerButton_toggled(button_pressed):
	if button_pressed:
		init_server()
	else:
		kill_connection()

func _on_ClientButton_toggled(button_pressed):
	if button_pressed:
		peer.create_client(SERVER_IP, SERVER_PORT)
		get_tree().set_multiplayer_peer(peer)
	else:
		kill_connection()

@rpc("any_peer") func create_client(id):
	var pos = Vector2(0,0)
	positions[id] = pos
	rotations[id] = 0
	players[id] = spawn.spawn_mp_player(str(id), pos)

@rpc("any_peer") func delete_client(id):
	players[id].queue_free()
	players.erase(id)
	positions.erase(id)
	rotations.erase(id)

func client_connect(id):
	for id_2 in players.keys():
		if id_2 != get_tree().get_unique_id():
			rpc_id(id_2, "create_client", id)
		rpc_id(id, "create_client", id_2)
	create_client(id)

func client_disconnect(id):
	rpc("delete_client", id)
	delete_client(id)

func send_ping():
	t_time = OS.get_system_time_msecs()
	rpc_id(1, "get_ping")

@rpc("any_peer") func get_ping():
	rpc_id(get_tree().get_remote_sender_id(), "compute_ping")

@rpc("any_peer") func compute_ping():
	var r_time = OS.get_system_time_msecs()
	ping_display.text = "Ping: " + str(r_time - t_time) + "ms"

@rpc("any_peer") func client_send_player_data(): #send own player data
	var id = get_tree().get_unique_id()
	rpc_unreliable_id(1, "refresh_player_data", player.position, player.rotation, id)

@rpc("any_peer") func refresh_player_data(position, rotation, id): #update data with newly received player data
	positions[id] = position
	rotations[id] = rotation

func server_actions():
	rset_unreliable("positions", positions)
	rset_unreliable("rotations", rotations)
	
	rpc_unreliable("client_send_player_data") #force all clients to send new player data
	refresh_player_data(player.position, player.rotation, 1) #update server player data itself
	
	refresh_world()

func refresh_world():
	var my_id = get_tree().get_unique_id()
	for id in players.keys(): #update all other player positions/rotations
		if id != my_id:
			var node = players[id]
			node.position = positions[id]
			node.rotation = rotations[id]

func client_actions():
	refresh_world()
	send_ping()

func _process(delta):
	if !get_tree().has_multiplayer_peer() or get_tree().get_peers().size() == 0:
		return
	
	if get_tree().is_server():
		server_actions()
	else:
		client_actions()
