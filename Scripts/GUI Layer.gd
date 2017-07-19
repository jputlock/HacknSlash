extends CanvasLayer

onready var music_player = get_node("MusicPlayer")

var songs = []
var muted = false

func _ready():
	randomize()
	load_songs()
	set_fixed_process(true)
	set_process_input(true)

func _fixed_process(delta):
	music_player.set_volume(1.3)
	var song = songs[randi() % songs.size()]
	if not music_player.is_playing():
		if music_player.get_stream() != song:
			music_player.set_stream(song)
		music_player.play()

func _input(event):
	if event.is_action_pressed("mute"):
		muted = not muted
		music_player.set_paused(muted)

func load_songs():
	songs.append(load("res://Sounds/dota2.ogg"))
	songs.append(load("res://Sounds/Path To Lake Land.ogg"))