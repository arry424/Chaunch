extends Node

var rng = RandomNumberGenerator.new()

var tree_scn = preload("res://scenes/tree.tscn")
var rock_scn = preload("res://scenes/rock.tscn")
var bush_scn = preload("res://scenes/bush.tscn")
var player_scn = preload("res://scenes/player.tscn")
@onready var win = $Win
@onready var score_label = $ScoreLabel
@onready var sound_timeout = $SoundTimeout
@onready var viewport_1 = $GridContainer/SubViewportContainer/SubViewport
@onready var viewport_2 = $GridContainer/SubViewportContainer2/SubViewport
var player_1: CharacterBody3D
var player_2: CharacterBody3D

# todo: create the other objects(tree, rock, bush) and preload them

# Called when the node enters the scene tree for the first time.
func get_random_position(radius: float) -> Vector3:
	var x = rng.randf_range(-radius, radius)
	var z_range = pow(radius**2 - x**2, 0.5)
	var z = rng.randf_range(-z_range, z_range)
	return Vector3(x, 0, z)

func _ready():	
	$AudioStreamPlayer.play(Music.musicProgress)   
	var throwable = rock_scn.instantiate()
	for i in range(10):
		var pos = get_random_position(23)
		if i < 2:
			throwable = tree_scn.instantiate()
		elif i < 5:
			throwable = bush_scn.instantiate()
		else:
			throwable = rock_scn.instantiate()
		self.add_child.call_deferred(throwable)
		#throwable.contact_monitor = true
		#throwable.max_contacts_reported = 1
		throwable.position = Vector3(pos.x, 6, pos.z)
	
	player_1 = player_scn.instantiate()
	player_2 = player_scn.instantiate()
	player_2.is_player_one = false
	for key in player_2.actions:
		player_2.actions[key] = player_2.actions[key] + "_2"
	
	var pos_1 = get_random_position(23)
	viewport_1.add_child.call_deferred(player_1)
	player_1.position = Vector3(pos_1.x, 6, pos_1.z)
	var pos_2 = get_random_position(23)
	viewport_2.add_child.call_deferred(player_2)
	player_2.position = Vector3(pos_2.x, 6, pos_2.z)
	
	
		
func _input(event):
	if event.is_action_pressed("restart"):
		get_tree().reload_current_scene()
		
func _process(_delta):
	score_label.text = str(Score.score_1) + "-" + str(Score.score_2)
	if player_1.hp <= 0 or player_2.hp <= 0:
		if sound_timeout.is_stopped():
			sound_timeout.start()
			await sound_timeout.timeout
			print("hello")
		else:
			return
		if player_1.hp <= 0:
			Score.score_2 += 1
		else:
			Score.score_1 += 1
		
	
		if Score.score_1 == 3 || Score.score_2 == 3:
			score_label.text = str(Score.score_1) + "-" + str(Score.score_2)
			var winner = "1" if Score.score_1 == 3 else "2"
			win.text = "Player " + winner + " Wins"
			win.process_mode = Node.PROCESS_MODE_WHEN_PAUSED
			win.visible = true
			get_tree().paused = true
			win.get_child(0).grab_focus()
		else:
			Music.musicProgress = $AudioStreamPlayer.get_playback_position()
			
			get_tree().reload_current_scene()
	


func _on_back_button_down():
	get_tree().paused = false 	
	get_tree().change_scene_to_file("res://scenes/main_menu.tscn")
