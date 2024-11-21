extends CanvasModulate

# this can be used to make the level much darker, let the player know that she's almost dead (red), etc.
func tint_canvas(color=Color(1,1,1,1)): #tints the entire 2d canvas
	color = color

func reset_canvas():
	tint_canvas()
