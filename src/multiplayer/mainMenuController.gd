extends Control

@export var address = "127.0.0.1"
@export var port = 9001
@export var player_scene: PackedScene
@export var lobby_node: Node
@export var loading_label: Label

var peer


func _ready() -> void:
	call_deferred("set_multiplayer_authority", (str(name).to_int()))

	multiplayer.peer_connected.connect(player_connected)
	multiplayer.peer_disconnected.connect(player_disconnected)
	multiplayer.connected_to_server.connect(connected_to_server)
	multiplayer.connection_failed.connect(connection_failed)
	
	pass
	

# server + client
func player_connected(id):
	print('player connected ', id)
	set_player_joined("2")

# server + client
func player_disconnected(id):
	print('player disconnected ', id)

# clients only
func connected_to_server():
	print('connected_to_server')
	send_player_info.rpc_id(1, "", multiplayer.get_unique_id())
	self.loading_label.text = "Joined!"

# clients only
func connection_failed():
	print('connection failed')
	
func set_player_joined(id: String):
	var newLabel = Label.new()
	newLabel.text = "Player {id}".format({"id": id})
	self.lobby_node.get_child(1).add_child(newLabel)

func _on_host_button_pressed() -> void:
	self.lobby_node.visible = true
	self.lobby_node.get_child(0).text = "Players in lobby:\n\n {ip}:{port}:".format({"ip": self.address, "port": self.port})
	set_player_joined("1")
	
	peer = ENetMultiplayerPeer.new()
	var error = peer.create_server(port, 2) # max 32 at once
	if error != OK:
		print('cannot host')
		return
	peer.get_host().compress(ENetConnection.COMPRESS_RANGE_CODER)
	
	multiplayer.set_multiplayer_peer(peer)
	print("Waiting for players")
	send_player_info("", multiplayer.get_unique_id())

func _on_join_button_pressed() -> void:
	self.loading_label.visible = true
	peer = ENetMultiplayerPeer.new()
	peer.create_client(address, port)
	peer.get_host().compress(ENetConnection.COMPRESS_RANGE_CODER)  # this needs to be same compression as above
	multiplayer.set_multiplayer_peer(peer)

func _on_play_button_pressed() -> void:
	send_player_info("", multiplayer.get_unique_id())
	start_game.rpc()

@rpc("any_peer")
func send_player_info(name, id):
	if !game.players.has(id):
		game.players[id] = {
			"name": name,
			"id": id,
		}
	if multiplayer.is_server():
		for i in game.players:
			send_player_info.rpc(game.players[i].name, i)

@rpc("any_peer", "call_local")
func start_game():
	get_tree().change_scene_to_file("res://scenes/main_game.tscn")

func _on_ip_address_input_text_changed(new_text: String) -> void:
	address = new_text
