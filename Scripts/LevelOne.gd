extends Node

onready var player = get_node("World/Walls/Player")
onready var zombie = get_node("World/Walls/Zombie")

onready var pause_label = get_node("GUI Layer/GUI/Pause")
onready var screen_size = Vector2(Globals.get("display/width"), Globals.get("display/height"))

func _ready():
	set_process_input(true)
	set_pause_mode(PAUSE_MODE_PROCESS)

func _input(event):
	if event.is_action_pressed("exit"):
		get_tree().quit()
	if event.is_action_pressed("fullscreen"):
		OS.set_window_fullscreen(not OS.is_window_fullscreen())
	if event.is_action_pressed("ui_cancel"):
		if get_tree().is_paused():
			pause_label.hide()
			get_tree().set_pause(false)
		else:
			pause_label.set_pos(screen_size / 2)
			pause_label.show()
			get_tree().set_pause(true)
	if event.is_action_pressed("healthup"):
		player.edit_health(10)
	if event.is_action_pressed("healthdown"):
		player.edit_health(-10)