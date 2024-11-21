extends TextureButton

@onready var NameNode = get_parent().get_parent().get_node("ItemName")
@onready var DescNode = NameNode.get_node("ItemDescription")
@onready var ImgNode = get_node("ItemImage")

var item_node_name = "" #name of the item's node, useful for dropping item, etc
var item_name = "" #item name shown in inventory description
var item_description = "" #item security clearance shown in inventory description

func _ready():
	set_process(false)
	inventory.connect("item_grabbed", Callable(self, "update_inv"))
	inventory.connect("item_dropped", Callable(self, "update_inv"))
	inventory.connect("reload_inv", Callable(self, "update_inv"))

func update_inv():
	ImgNode.texture = null
	item_description = ""
	item_name = ""
	item_node_name = ""
	
	var i = 0
	for item in inventory.inventory.keys():
		if i == get_index():
			var dict = inventory.inventory[item]
			ImgNode.texture = load(dict["texture"]).duplicate()
			ImgNode.texture.flags = 0 #deactivate filter for big resolution
			item_description = dict["item_description"]
			item_name = dict["item_name"]
			item_node_name = item
		i += 1
	
	NameNode.text = item_name
	DescNode.text = item_description

func _on_Slot1_gui_input(event):
	if event.is_action_pressed("drop_item") and !item_node_name.is_empty():
		accept_event()
		inventory.drop(item_node_name)

func _on_Slot1_mouse_entered():
	NameNode.show()
	NameNode.text = item_name
	DescNode.text = item_description

func _on_Slot1_mouse_exited():
	NameNode.hide()
