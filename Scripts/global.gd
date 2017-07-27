extends Node

# Adapted from the page on Background Loading from the Godot forums

var loader
var wait_frames
var time_max = 100 # msec
var current_scene

func _ready():
	var root = get_tree().get_root()
	current_scene = root.get_child( root.get_child_count() -1 )
	Globals.set("mouse_state", "MOVE")

func goto_scene(path): # game requests to switch to this scene
	loader = ResourceLoader.load_interactive(path)
	if loader == null: # check for errors
		show_error()
		return
	set_process(true)
	
	current_scene.queue_free() # get rid of the old scene
	
	### START ANIMATION
	
	# create black background
	var background = TextureFrame.new()
	background.set_texture(load("res://Textures/gui/pause_menu_2.png"))
	add_child(background)
	
	# create progress bar
	var progress_bar = TextureProgress.new()
	progress_bar.set_over_texture(load("res://Textures/gui/EnemyHealthBarOver.png"))
	progress_bar.set_under_texture(load("res://Textures/gui/EnemyHealthBarUnder.png"))
	progress_bar.set_progress_texture(load("res://Textures/gui/EnemyHealthBar.png"))
	progress_bar.set_name("progress")
	progress_bar.set_pos(Vector2((Globals.get("display/width") - progress_bar.get_over_texture().get_width()) / 2, (Globals.get("display/height") - progress_bar.get_over_texture().get_height()) / 2))
	add_child(progress_bar)
	
	# create label
	var loading_label = Label.new()
	loading_label.set_text("Loading...")
	progress_bar.add_child(loading_label)
	loading_label.set_pos(Vector2((progress_bar.get_over_texture().get_width() - loading_label.get_size().x) / 2, (progress_bar.get_over_texture().get_height() - loading_label.get_size().y) / 2))
	loading_label.set_align(1)
	loading_label.set_valign(1)
	
	wait_frames = 1


func _process(time):
	if loader == null:
		# no need to process anymore
		set_process(false)
		return
	
	if wait_frames > 0: # wait for frames to let the "loading" animation to show up
		wait_frames -= 1
		return
	
	var t = OS.get_ticks_msec()
	while OS.get_ticks_msec() < t + time_max: # use "time_max" to control how much time we block this thread
	
		# poll your loader
		var err = loader.poll()
		
		if err == ERR_FILE_EOF: # load finished
			var resource = loader.get_resource()
			loader = null
			set_new_scene(resource)
			break
		elif err == OK:
			update_progress()
		else: # error during loading
			print(err)
			loader = null
			break

func update_progress():
	var progress = 100 * loader.get_stage() / loader.get_stage_count()
	# update your progress bar?
	get_node("progress").set_value(progress)

# or update a progress animation?
#	var len = get_node("animation").get_current_animation_length()

# call this on a paused animation. use "true" as the second parameter to force the animation to update
#	get_node("animation").seek(progress * len, true)

func set_new_scene(scene_resource):
	current_scene = scene_resource.instance()
	get_node("/root").add_child(current_scene)