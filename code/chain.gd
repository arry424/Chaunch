extends RigidBody3D
var canPickUp = true

var last_held_object: RigidBody3D
var last_collided_object: RigidBody3D
var is_colliding = false
# Called when the node enters the scene tree for the first time.
func _ready():
	#contact_monitor = true
	#max_contacts_reported = 1
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Input.is_action_pressed("pick_up") and canPickUp and is_colliding:
		last_collided_object.reparent(self)
		last_collided_object.freeze = true
		canPickUp = false
		last_held_object = last_collided_object
		is_colliding = false
	
	if Input.is_action_pressed("throw") && !canPickUp:
		last_held_object.reparent(get_tree().root)
		last_held_object.freeze = false
		last_held_object.set_axis_velocity(Vector3(0,10,-6))
		canPickUp = true


func _on_area_3d_body_entered(body):
	is_colliding = true
	last_collided_object = body

func _on_area_3d_body_exited(body):
	is_colliding = false
