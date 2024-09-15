extends Control


func _ready():
	Score.score_1 = 0
	Score.score_2 = 0
	$VBoxContainer/PlayButton.grab_focus()

func _on_play_button_button_down():
	get_tree().change_scene_to_file("res://scenes/main.tscn")



func _on_quit_button_button_down():
	get_tree().quit()


func _on_how_to_play_button_down():
	get_tree().change_scene_to_file("res://scenes/tutorial.tscn")
