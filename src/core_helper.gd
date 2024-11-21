extends Node

var RNG = RandomNumberGenerator.new() #random number generator, will take care of randomness and seeds

func _ready():
	RNG.randomize()
	RNG.seed = 173

func rand_int(min_int, max_int):
	return RNG.randi_range(min_int, max_int)

func rand_float(min_f, max_f):
	return RNG.randf_range(min_f, max_f)
