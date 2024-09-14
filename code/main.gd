extends Node

@export var tree_ct = 3
@export var rock_ct = 7
@export var bush_ct = 5

var rng = RandomNumberGenerator.new()

var chain_ball_obj_scn = preload("res://scenes/chain_ball_object.tscn")
# todo: create the other objects(tree, rock, bush) and preload them

# Called when the node enters the scene tree for the first time.
func _ready():
	for i in range(10):
		var x = rng.randf_range(-30, 30)
		var z_range = pow(900.0 - x**2, 0.5)
		var z = rng.randf_range(-z_range, z_range)
		var chain_ball = chain_ball_obj_scn.instantiate()
		get_tree().root.add_child.call_deferred(chain_ball)
		chain_ball.contact_monitor = true
		chain_ball.max_contacts_reported = 1
		chain_ball.position = Vector3(x, 1, z)
		
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
