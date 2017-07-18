extends Node

onready var player = get_node("World/Walls/Player")

onready var pause_label = get_node("GUI Layer/GUI/Pause")
onready var health_bar = get_node("GUI Layer/GUI/BottomBar/HealthFrame/HealthBar")
onready var mana_bar = get_node("GUI Layer/GUI/BottomBar/ManaFrame/ManaBar")
onready var screen_size = Vector2(Globals.get("display/width"), Globals.get("display/height"))

func _ready():
	set_process_input(true)
	set_fixed_process(true)
	set_pause_mode(PAUSE_MODE_PROCESS)

func _fixed_process(delta):
	health_bar.set_max(player.MAX_HEALTH)
	mana_bar.set_max(player.MAX_MANA)
	
	health_bar.set_value(player.health)
	mana_bar.set_value(player.mana)
	
	health_bar.get_node("Label").set_text("%d/%d\n(+%d)" % [health_bar.get_value(), health_bar.get_max(), player.health_regen])
	mana_bar.get_node("Label").set_text("%d/%d\n(+%d)" % [mana_bar.get_value(), mana_bar.get_max(), player.mana_regen])

func _input(event):
	if event.is_action_pressed("exit"):
		get_tree().quit()
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