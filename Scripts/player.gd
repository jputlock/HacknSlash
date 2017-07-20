extends KinematicBody2D

const MAX_SPEED = 80
var direction = Vector2()

onready var animator = get_node("AnimationPlayer")
onready var Fireball = preload("res://Nodes/Fireball.tscn")
onready var screen_size = Vector2(Globals.get("display/width"), Globals.get("display/height"))
onready var player_camera = get_node("Camera2D")

onready var health_bar = get_tree().get_root().get_node("Game/GUI Layer/GUI/BottomBar/HealthFrame/HealthBar")
onready var mana_bar = get_tree().get_root().get_node("Game/GUI Layer/GUI/BottomBar/ManaFrame/ManaBar")

#Animation Vars
var animation_names = []
#Ability Vars
var ability_timers = []
var ability_costs = [35, 0, 0, 0, 0]
var abilities_off_cooldown = []

# Stats

var MAX_HEALTH = 100
var MAX_MANA = 100

var health = 100
var mana = 100

var health_regen = 1
var mana_regen = 5

var enemy_range = 250

func _ready():
	set_process_input(true)
	set_fixed_process(true)
	health = MAX_HEALTH
	for i in range(5):
		abilities_off_cooldown.append(true)
		var new_timer = Timer.new()
		new_timer.connect("timeout", self, "cooldown", [i])
		ability_timers.append(new_timer)
		add_child(new_timer)

func _fixed_process(delta):
	handle_movement(delta)
	handle_regen(delta)
	manage_status_bars()

func _input(event):
	var mouse_on_screen = get_viewport().get_mouse_pos() - screen_size / 2
	var player_on_screen = get_pos() - player_camera.get_camera_screen_center()
	var mouse_pos = mouse_on_screen - player_on_screen
	if event.is_action_pressed("first_ability"):
		if abilities_off_cooldown[0]:
			if mana >= ability_costs[0]:
				mana -= ability_costs[0]
				print("FIREBALL!!!!")
				abilities_off_cooldown[0] = false
				ability_timers[0].set_wait_time(2)
				ability_timers[0].start()
				var fball = Fireball.instance()
				var pos = get_pos() + Vector2(0, 20) + mouse_pos.normalized() * 30
				var angle = atan2(mouse_pos.x, mouse_pos.y) - PI / 2
				fball.set_rot(angle)
				fball.set_pos(pos)
				fball.set_linear_velocity(100 * Vector2(cos(angle), -sin(angle)))
				get_tree().get_root().get_node("Game/World/Walls").add_child(fball)
			else:
				print("You need %d more mana to cast that" % (ability_costs[0] - mana))
		else:
			print("You must wait %.2f seconds to cast that" % ability_timers[0].get_time_left())
	if event.is_action_pressed("health_potion"):
		edit_health(25)
	if event.is_action_pressed("healthdown"):
		edit_health(-10)

func is_alive():
	return health > 0

func handle_regen(delta):
	edit_health(health_regen * delta)
	edit_mana(mana_regen * delta)

func manage_status_bars():
	health_bar.set_max(MAX_HEALTH)
	mana_bar.set_max(MAX_MANA)
	
	health_bar.set_value(health)
	mana_bar.set_value(mana)
	
	health_bar.get_node("Label").set_text("%d/%d\n(+%d)" % [health, MAX_HEALTH, health_regen])
	mana_bar.get_node("Label").set_text("%d/%d\n(+%d)" % [mana, MAX_MANA, mana_regen])

func edit_health(health_to_add):
	health += health_to_add
	if health > MAX_HEALTH:
		health = MAX_HEALTH
	if health < 0:
		health = 0

func edit_mana(mana_to_add):
	mana += mana_to_add
	if mana > MAX_MANA:
		mana = MAX_MANA
	if mana < 0:
		mana = 0

func handle_movement(delta):
	var motion = Vector2()
	
	motion.y = Input.is_action_pressed("ui_down") - Input.is_action_pressed("ui_up")
	motion.x = Input.is_action_pressed("ui_right") - Input.is_action_pressed("ui_left")
	if(motion.length() != 0):
		direction = motion
	handle_animations(direction, motion.length() > 0)
	
	motion *= MAX_SPEED * delta
	move(motion)
	
	# Make character slide nicely through the world
	var slide_attempts = 4
	while(is_colliding() and slide_attempts > 0):
		motion = get_collision_normal().slide(motion)
		motion = move(motion)
		slide_attempts -= 1

func cooldown(i):
	abilities_off_cooldown[i] = true

# Sets the correct animation based on the orientation
func handle_animations(direction, is_moving):
	var sum = direction.x + direction.y
	
	if is_moving > 0:
		# Moving
		if direction.x > 0:
			#0, 1, 2
			if sum == 0:
				if animator.get_current_animation() != "movetopright":
					animator.set_current_animation("movetopright")
			elif sum == 1:
				if animator.get_current_animation() != "moveright":
					animator.set_current_animation("moveright")
			elif sum == 2:
				if animator.get_current_animation() != "movebotright":
					animator.set_current_animation("movebotright")
			else:
				print("Moving player animation errors 1")
		elif direction.x < 0:
			#0, -1, -2
			if sum == 0: 
				if animator.get_current_animation() != "movebotleft":
					animator.set_current_animation("movebotleft")
			elif sum == -1:
				if animator.get_current_animation() != "moveleft":
					animator.set_current_animation("moveleft")
			elif sum == -2:
				if animator.get_current_animation() != "movetopleft":
					animator.set_current_animation("movetopleft")
			else:
				print("Moving player animation errors 2")
		else:
			#-1, 1
			if sum == -1:
				if animator.get_current_animation() != "movetop":
					animator.set_current_animation("movetop")
			elif sum == 1:
				if animator.get_current_animation() != "movebot":
					animator.set_current_animation("movebot")
			else:
				print("Moving player animation errors 3")
	else:
		# Idle
		if direction.x > 0:
			#0, 1, 2
			if sum == 0:
				if animator.get_current_animation() != "idletopright":
					animator.set_current_animation("idletopright")
			elif sum == 1:
				if animator.get_current_animation() != "idleright":
					animator.set_current_animation("idleright")
			elif sum == 2:
				if animator.get_current_animation() != "idlebotright":
					animator.set_current_animation("idlebotright")
			else:
				print("Idle player animation errors 1")
		elif direction.x < 0:
			#0, -1, -2
			if sum == 0:
				if animator.get_current_animation() != "idlebotleft":
					animator.set_current_animation("idlebotleft")
			elif sum == -1:
				if animator.get_current_animation() != "idleleft":
					animator.set_current_animation("idleleft")
			elif sum == -2:
				if animator.get_current_animation() != "idletopleft":
					animator.set_current_animation("idletopleft")
			else:
				print("Idle player animation errors 2")
		else:
			#-1, 1, 0
			if sum == -1:
				if animator.get_current_animation() != "idletop":
					animator.set_current_animation("idletop")
			elif sum == 1:
				if animator.get_current_animation() != "idlebot":
					animator.set_current_animation("idlebot")
			elif sum == 0:
				pass #no keys have been pressed yet
			else:
				print("Idle player animation errors 3")