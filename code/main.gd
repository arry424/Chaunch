extends Node

@export var tree_ct = 3
@export var rock_ct = 7
@export var bush_ct = 5

var rng = RandomNumberGenerator.new()

var tree_scn = preload("res://scenes/tree.tscn")
var rock_scn = preload("res://scenes/rock.tscn")
var bush_scn = preload("res://scenes/bush.tscn")

# todo: create the other objects(tree, rock, bush) and preload them

# Called when the node enters the scene tree for the first time.
func _ready():	
	var throwable = rock_scn.instantiate()
	for i in range(10):
		var x = rng.randf_range(-30, 30)
		var z_range = pow(900.0 - x**2, 0.5)
		var z = rng.randf_range(-z_range, z_range)
		if i < 2:
			throwable = tree_scn.instantiate()
		elif i < 5 and i >= 2:
			throwable = bush_scn.instantiate()
		else:
			throwable = rock_scn.instantiate()
		get_tree().root.add_child.call_deferred(throwable)

		throwable.contact_monitor = true
		throwable.max_contacts_reported = 1
		throwable.position = Vector3(x, 1, z)
