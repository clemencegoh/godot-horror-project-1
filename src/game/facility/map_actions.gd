extends TileMap

var prev_pos = {} #Vector2()

func floor_material(): #get the floor material of the tile the player is moving on
	for Player in get_tree().get_nodes_in_group("player"):
		var pos = local_to_map(Player.position)
		
		if !prev_pos.has(Player):
			prev_pos[Player] = pos
		
		if prev_pos[Player] == pos:
			return
		
		prev_pos[Player] = pos
		
		#var name = tile_set.tile_get_name(get_cellv(pos))
		
		#if "metal" in name.to_lower():
			#Player.floor_material = "_metal"
		#else:
			#Player.floor_material = ""

func _physics_process(delta):
	floor_material()
