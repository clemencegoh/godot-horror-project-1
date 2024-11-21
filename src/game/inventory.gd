extends Node

var inventory = {}: set = setget_inv

signal item_dropped #optional: just update the inventory change instead of everything?
signal item_grabbed #in regard of performance pretty unimportant though
signal reload_inv #just reload the whole inventory with its contents. Used for loading save games

# ITEM STATS THAT <NEED> TO BE DEFINED FOR THIS TO WORK:
# -> bool has_clearance; this will set if one can use the item as sort of key(card)
# -> String item_name; shows in the inventory and info text
# -> string item_description; shows in inventory
# -> func save(); all the above and more will be saved into the according dictionary

func pickup(item):
	if inventory.size() < game.INVENTORY_SIZE:
		inventory[item.name] = {}
		var dict = inventory[item.name]
		
		dict["filename"] = item.filename #save item name with path and other info
		dict["path"] = item.get_parent().get_path()
		dict["texture"] = item.texture.resource_path
		
		var item_dict = item.save()["item_dict"]
		for data in item_dict:
			dict[data] = item_dict[data]
		
		if !item.has_clearance: #fix clearance
			dict["item_clearance"] = -1
		
		item.queue_free()
		emit_signal("item_grabbed")
	else:
		print("Inventory is full!")
		#print user-readable hint

func drop(name):
	for player in get_tree().get_nodes_in_group("player"): #drop item at every "player" node
		var item = spawn.spawn_item(inventory[name]["filename"], inventory[name]["path"], name, player.position, player.rotation - PI/2)
		
		for value in inventory[item.name].keys(): #restore all of the original data
			item.set(value, inventory[item.name][value])
			
		inventory.erase(name)
		emit_signal("item_dropped")

func setget_inv(new_inv):
	inventory = new_inv
	emit_signal("reload_inv")
