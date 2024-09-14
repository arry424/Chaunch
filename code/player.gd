extends CharacterBody3D

@export var max_hp = 50
var hp = max_hp
var is_player_one = true

@export var move_left = "move_left"
@export var move_right = "move_right"
@export var move_forward = "move_forward"
@export var move_back = "move_back"
@export var sprint = "sprint"
@export var jump = "jump"


const SPEED = 5.0
const JUMP_VELOCITY = 4.5

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")
#@onready var camera = $Camera3D

var look_dir: Vector2
var camera_sens = 50

var is_sprinting = false

func _ready():
	#if !is_player_one:
		#set_collision_layer_value(1, false)
		#set_collision_layer_value(2, true)
	pass

func _physics_process(delta):
	# Add the gravity.
	if not is_on_floor():
		velocity.y -= gravity * delta

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
	_rotate_camera(delta)
	move_and_slide()
	
	
func _input(event: InputEvent):
	if event is InputEventMouseMotion: look_dir = event.relative * 0.01
	
func _rotate_camera(delta: float, sens_mod: float = 1.0):
	#var input = Input.get_vector("look_left","look_right","look_up","look_down")
	#look_dir += input
	rotation.y -= look_dir.x * camera_sens * delta
	#print(rotation.y)
	#camera.rotation.x = clamp(camera.rotation.x - look_dir.y * camera_sens * sens_mod* delta, -90, 90)
	look_dir = Vector2.ZERO
	
func _process(delta):
	if Input.is_action_just_pressed(sprint):
		is_sprinting = true
	if Input.is_action_just_released(sprint):
		is_sprinting = false
		

