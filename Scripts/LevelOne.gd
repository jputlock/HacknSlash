extends Node

onready var pause_menu = get_node("GUI Layer/GUI/PauseMenu")
onready var screen_size = Vector2(Globals.get("display/width"), Globals.get("display/height"))
#onready var Zombie = preload("res://Nodes/Zombie.tscn")

func _ready():
	set_process_input(true)
	set_pause_mode(PAUSE_MODE_PROCESS)

func _input(event):
	if event.is_action_pressed("ui_cancel"):
		if get_tree().is_paused():
			pause_menu.hide()
			get_tree().set_pause(false)
		else:
			pause_menu.show()
			get_tree().set_pause(true)
	if event.is_action_pressed("exit"):
		get_tree().quit()
#	if event.is_action_pressed("spawn_zombie") and not get_tree().is_paused():
#		print("zombie!")
#		var zomb = Zombie.instance()
#		print(get_node("World").get_global_mouse_pos())
#		zomb.set_pos(Vector2(get_node("World").get_global_mouse_pos()))
#		get_node("World/Navigation2D/Walls").add_child(zomb)
	if event.is_action_pressed("fullscreen"):
		OS.set_window_fullscreen(not OS.is_window_fullscreen())