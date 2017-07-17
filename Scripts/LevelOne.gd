extends Node

onready var pause_label = get_node("Pause")
onready var player_camera = get_node("World/Walls/Player/Camera2D")

func _ready():
	set_process_input(true)
	set_fixed_process(true)
	set_pause_mode(PAUSE_MODE_PROCESS)

func _fixed_process(delta):
	pause_label.set_pos(player_camera.get_camera_screen_center())

func _input(event):
	if event.is_action_pressed("ui_cancel"):
		if get_tree().is_paused():
			pause_label.hide()
			get_tree().set_pause(false)
		else:
			pause_label.show()
			get_tree().set_pause(true)
