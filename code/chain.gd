extends RigidBody3D
var canPickUp = true

var last_held_object: RigidBody3D
var last_collided_object: RigidBody3D
var is_colliding = false
@onready var ray = $RayCast3D

@export var pick_up = "pick_up"
@export var throw = "throw"
# Called when the node enters the scene tree for the first time.
func _ready():
	ray.target_position = Vector3(0,0,10)
	#contact_monitor = true
	#max_contacts_reported = 1
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Input.is_action_pressed(pick_up) and canPickUp and is_colliding:
		last_collided_object.reparent(self)
		last_collided_object.freeze = true
		last_collided_object.position = Vector3(0.2, 0, 0)
		last_collided_object.rotation = Vector3(-45, 0, 0)
		last_collided_object.set_collision_layer_value(7, false)
		last_held_object = last_collided_object
		canPickUp = false
		is_colliding = false
	
	if Input.is_action_pressed(throw) && !canPickUp:
		last_held_object.reparent(get_tree().root)
		last_held_object.freeze = false
		last_held_object.get_child(0).set_collision_mask_value(1, true)
		last_held_object.get_child(0).set_collision_mask_value(2, true)
		last_held_object.set_collision_layer_value(7, true)
		
		var distance = 10
		var local_direction = Vector3(0, 0, -1)  # Local direction, forward
		var world_direction = global_transform.basis * local_direction 
		ray.target_position = world_direction * distance
		var direction_vector = ray.get_target_position()
		#direction_vector = direction_vector.normalized()  # Normalize for unit length
		print(direction_vector)
		last_held_object.set_axis_velocity(Vector3(direction_vector.x * 3, 2, direction_vector.z * 3))
		canPickUp = true


func _on_area_3d_body_entered(body):
	is_colliding = true
	last_collided_object = body

func _on_area_3d_body_exited(body):
	is_colliding = false
