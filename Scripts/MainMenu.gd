extends Control

func _ready():
	pass

func _on_Play_pressed():
	get_node("/root/global").goto_scene("res://Scenes/LevelOne.tscn")


func _on_Quit_pressed():
	get_tree().quit()
