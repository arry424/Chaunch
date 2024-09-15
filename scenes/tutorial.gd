extends Control


func _ready():
	$VBoxContainer/Button.grab_focus()

func _on_button_button_down():
	get_tree().change_scene_to_file("res://scenes/main_menu.tscn")
