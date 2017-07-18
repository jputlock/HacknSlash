extends Node

onready var pause_label = get_node("Pause")
onready var player_camera = get_node("World/Walls/Player/Camera2D")
onready var player = get_node("World/Walls/Player")

onready var health_bar = get_node("GUI Layer/GUI/HealthBar")
onready var mana_bar = get_node("GUI Layer/GUI/ManaBar")

func _ready():
	set_process_input(true)
	set_fixed_process(true)
	set_pause_mode(PAUSE_MODE_PROCESS)

func _fixed_process(delta):
	health_bar.set_max(player.MAX_HEALTH)
	mana_bar.set_max(player.MAX_MANA)
	health_bar.set_value(player.health)
	mana_bar.set_value(player.mana)
	

func _input(event):
	if event.is_action_pressed("ui_cancel"):
		if get_tree().is_paused():
			pause_label.hide()
			get_tree().set_pause(false)
		else:
			pause_label.set_pos(player_camera.get_camera_screen_center())
			pause_label.show()
			get_tree().set_pause(true)
	if event.is_action_pressed("healthdown"):
		player.remove_health(5)
	if event.is_action_pressed("healthup"):
		player.add_health(5)