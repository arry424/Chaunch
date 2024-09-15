extends RigidBody3D

@onready var hitbox = $Hitbox
@export var min_dmg_velocity = 3.0
@export var type = "throwable"
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	if linear_velocity.length() < min_dmg_velocity:
		hitbox.set_collision_mask_value(1, false)
		#hitbox.set_collision_mask_value(2, false)
	
func _on_hitbox_body_entered(body):
	#print("Hit")
	body.hp -= mass
	#print(body.hp)
	hitbox.set_collision_mask_value(1, false)
	#hitbox.set_collision_mask_value(2, false)

