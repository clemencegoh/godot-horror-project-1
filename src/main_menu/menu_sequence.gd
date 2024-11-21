extends TextureRect


func _ready():
	set_process(false)

func _process(delta):
	texture.width = get_window().get_size_with_decorations().x
	texture.height = get_window().get_size_with_decorations().y
	texture.noise.seed += 1
