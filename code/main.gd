extends Node

var rng = RandomNumberGenerator.new()

var tree_scn = preload("res://scenes/tree.tscn")
var rock_scn = preload("res://scenes/rock.tscn")
var bush_scn = preload("res://scenes/bush.tscn")

@onready var win = $Win
@onready var score_label = $ScoreLabel
@onready var player_1 = $GridContainer/SubViewportContainer/SubViewport/Player
@onready var player_2 = $GridContainer/SubViewportContainer2/SubViewport/Player2
# todo: create the other objects(tree, rock, bush) and preload them

# Called when the node enters the scene tree for the first time.
func _ready():	
	var throwable = rock_scn.instantiate()
	for i in range(10):
		var x = rng.randf_range(-23, 23)
		var z_range = pow(23**2 - x**2, 0.5)
		var z = rng.randf_range(-z_range, z_range)
		if i < 2:
			throwable = tree_scn.instantiate()
		elif i < 5:
			throwable = bush_scn.instantiate()
		else:
			throwable = rock_scn.instantiate()
		self.add_child.call_deferred(throwable)
		
		#throwable.contact_monitor = true
		#throwable.max_contacts_reported = 1
		throwable.position = Vector3(x, 1, z)
		
func _input(event):
	if event.is_action_pressed("restart"):
		get_tree().reload_current_scene()
		
func _process(_delta):
	#print("player 1 " + str(Score.score_1))
	#print("player 2 " + str(Score.score_2))
	if player_1.hp <= 0:
		Score.score_2 += 1
		get_tree().change_scene_to_file("res://scenes/main.tscn")
	elif player_2.hp <= 0:
		Score.score_1 += 1
		get_tree().change_scene_to_file("res://scenes/main.tscn")

				
	score_label.text = str(Score.score_1) + "-" + str(Score.score_2)
	if Score.score_1 == 3 || Score.score_2 == 3:
		var winner = "1" if Score.score_1 == 3 else "2"
		win.text = "Player " + winner + " Wins"
		win.process_mode = Node.PROCESS_MODE_WHEN_PAUSED
		win.visible = true
		get_tree().paused = true


func _on_back_button_down():
	get_tree().paused = false 	
	get_tree().change_scene_to_file("res://scenes/main_menu.tscn")
