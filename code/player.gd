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
	
	move_and_slide()
	
	
func _input(event: InputEvent):
	if event is InputEventMouseMotion: look_dir = event.relative * 0.01
	
	#if event is InputEventJoypadMotion: 
		#look_dir = Vector2(event.get_axis_value(), 0)
	 #
	
#func _rotate_camera(delta: float, sens_mod: float = 1.0):
#
	#rotation.y -= look_dir.x * camera_sens * delta
	#
	#look_dir = Vector2.ZERO
	
func _process(delta):
	if Input.is_action_just_pressed(sprint):
		is_sprinting = true
	if Input.is_action_just_released(sprint):
		is_sprinting = false
		
	#_rotate_camera(delta)
	rotation.y -= Input.get_axis(rotate_left, rotate_right) * 0.1

	#if is_player_one:
		#print("player 1 hp is " + str(hp))
	#else:
		#print("player 2 hp is " + str(hp))
	if hp <= 0:
		if is_player_one:
			Score.score_2 += 1
		else:
			Score.score_1 += 1
		if Score.score_1 < 3 && Score.score_2 < 3:
			get_tree().reload_current_scene()
