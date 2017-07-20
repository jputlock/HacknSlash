extends CanvasLayer

onready var music_player = get_node("MusicPlayer")
onready var sfx_player = get_node("SamplePlayer")

onready var sfx_button = get_node("GUI/PauseMenu/HBoxContainer/SFXButton")
onready var music_button = get_node("GUI/PauseMenu/HBoxContainer/MusicButton")

var songs = []
var music_muted = false
var sfx_muted = false

func _ready():
	randomize()
	load_songs()
	set_fixed_process(true)
	set_process_input(true)

func _fixed_process(delta):
	
	sfx_button.set_pressed(sfx_muted)
	music_button.set_pressed(music_muted)
	
	music_player.set_paused(music_muted)
	sfx_player.set_default_volume(not sfx_muted)
	var song = songs[randi() % songs.size()]
	if not music_player.is_playing():
		if music_player.get_stream() != song:
			music_player.set_stream(song)
		music_player.play()

func _input(event):
	if event.is_action_pressed("mute"):
		music_muted = not music_muted

func load_songs():
	songs.append(load("res://Sounds/pathtolakeland.ogg"))

func _on_ResumeButton_pressed():
	get_node("GUI/PauseMenu").hide()
	get_tree().set_pause(false)


func _on_ExitButton_pressed():
	get_tree().quit()


func _on_MusicButton_toggled( pressed ):
	music_muted = pressed


func _on_SFXButton_toggled( pressed ):
	sfx_muted = pressed
