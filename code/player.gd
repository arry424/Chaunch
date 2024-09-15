extends CharacterBody3D

@export var max_hp = 1
var hp = max_hp
@export var is_player_one = true

@export var move_left = "move_left"
@export var move_right = "move_right"
@export var move_forward = "move_forward"
@export var move_back = "move_back"
@export var sprint = "sprint"
@export var jump = "jump"
@export var rotate_left = "rotate_left"
@export var rotate_right = "rotate_right"
var canPickUp = true

var last_held_object: RigidBody3D
var last_collided_object: RigidBody3D
var is_colliding = false
var is_winding_up = false

@onready var animation = $AnimationPlayer
@onready var tight = $"MeshInstance3D/Chain3(straight-tight)"
@onready var loose = $"MeshInstance3D/Chain4(snake-shaped)"
@onready var ray = $RayCast3D

@export var pick_up = "pick_up"
@export var throw = "throw"


const SPEED = 5.0
const JUMP_VELOCITY = 4.5
const BASE_WINDUP_TIME = 0.3
const RECOVERY_TIME = 0.4
# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")


var look_dir: Vector2
var camera_sens = 50
var done_anim = true


var is_sprinting = false

func _ready():
	ray.target_position = Vector3(0,0,10)
	
	pass

func _physics_process(delta):
	# Add the gravity.
	if not is_on_floor():
		velocity.y -= gravity * delta
	
	if is_winding_up:
		return
	# Handle jump.
	if Input.is_action_just_pressed(jump) and is_on_floor():
		velocity.y = JUMP_VELOCITY
	

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var input_dir = Input.get_vector(move_left, move_right, move_forward, move_back)
	var direction = (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if direction:
		velocity.x = direction.x * SPEED
		velocity.z = direction.z * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.z = move_toward(velocity.z, 0, SPEED)
	if is_sprinting:
		velocity.x = velocity.x * 2
		velocity.z = velocity.z * 2
	
	move_and_slide()
	
	
func _process(_delta):
	if Input.is_action_just_pressed(sprint):
		is_sprinting = true
	if Input.is_action_just_released(sprint):
		is_sprinting = false
		
	rotation.y -= Input.get_axis(rotate_left, rotate_right) * 0.1

	#if is_player_one:
		#print("player 1 hp is " + str(hp))
	#else:
		#print("player 2 hp is " + str(hp))
	
	if is_winding_up:
		return
		
	if Input.is_action_just_pressed(pick_up) and canPickUp and is_colliding:
		loose.set_visible(false)
		tight.set_visible(true)
		last_collided_object.reparent($MeshInstance3D)
		last_collided_object.freeze = true
		last_collided_object.position = Vector3(0, 0, -2)
		last_collided_object.rotation = Vector3(0, 0, -90)
		last_collided_object.set_collision_layer_value(7, false)
		last_held_object = last_collided_object
		canPickUp = false
		is_colliding = false
	
	if Input.is_action_just_pressed(throw) && !canPickUp:
		
		
		is_winding_up = true
		animation.play("spin_attack")
		
		var multiplier = 1
		if last_held_object.type == "tree":
			multiplier = 3
		elif last_held_object.type == "bush":
			multiplier = 2
		await get_tree().create_timer(BASE_WINDUP_TIME * multiplier + 0.01).timeout
		
		last_held_object.reparent(get_node("/root/Main"))
		last_held_object.freeze = false
		last_held_object.get_child(0).set_collision_mask_value(1, true)
		#last_held_object.get_child(0).set_collision_mask_value(2, true)
		last_held_object.set_collision_layer_value(7, true)
		
		var distance = 10
		var local_direction = Vector3(0, 0, -1)  # Local direction, forward
		var direction_vector = global_transform.basis * local_direction 
		print(direction_vector)
		last_held_object.set_axis_velocity(Vector3(direction_vector.x * 30, 0, direction_vector.z * 30))
		canPickUp = true
		is_winding_up = false
		
		animation.play("recover")
		loose.set_visible(true)
		tight.set_visible(false)
		
		await get_tree().create_timer(RECOVERY_TIME).timeout
func _on_area_3d_body_entered(body):
	is_colliding = true
	last_collided_object = body


func _on_area_3d_body_exited(_body):
	is_colliding = false



	
