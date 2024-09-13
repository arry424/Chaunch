extends Node

@export var tree_ct = 3
@export var rock_ct = 7
@export var bush_ct = 5

var rng = RandomNumberGenerator.new()
# Called when the node enters the scene tree for the first time.
func _ready():
	var x = rng.randf_range(-30, 30)
	var z = rng.randf_range(-30, 30)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
