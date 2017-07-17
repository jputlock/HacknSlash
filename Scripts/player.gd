extends KinematicBody2D

const MAX_SPEED = 80
var direction = Vector2()

onready var sprite = get_node("AnimatedSprite")
onready var Fireball = preload("res://Nodes/Fireball.tscn")
onready var screen_size = Vector2(Globals.get("display/width"), Globals.get("display/height"))
onready var player_camera = get_node("Camera2D")

#Animation Vars
var animation_names = []
#Ability Vars
var ability_timers = []
var can_shoot_ability = []
var fireballs = []

func _ready():
	set_process_input(true)
	set_fixed_process(true)
	for i in range(5):
		can_shoot_ability.append(true)
		var new_timer = Timer.new()
		print("cooldown%d" % i)
		new_timer.connect("timeout", self, "cooldown%d" % i)
		ability_timers.append(new_timer)
		add_child(new_timer)

func _fixed_process(delta):
	handle_movement(delta)
	handle_abilities()

func _input(event):
	var mouse_on_screen = get_viewport().get_mouse_pos() - screen_size / 2
	var player_on_screen = get_pos() - player_camera.get_camera_screen_center()
	var mouse_pos = mouse_on_screen - player_on_screen
	if event.is_action_pressed("first_ability"):
		if can_shoot_ability[0]:
			print("FIREBALL!!!!")
			can_shoot_ability[0] = false
			ability_timers[0].set_wait_time(2)
			ability_timers[0].start()
			var fball = Fireball.instance()
			var pos = get_pos() + Vector2(0, 20) + mouse_pos.normalized() * 30
			var angle = atan2(mouse_pos.x, mouse_pos.y) + PI / 2
			fball.set_rot(angle)
			fball.set_pos(pos)
			fball.set_linear_velocity(100 * Vector2(cos(angle - PI), -sin(angle - PI)))
			fireballs.append(fball)
			get_tree().get_root().get_node("Game/World/Walls").add_child(fball)
		else:
			print("You must wait %.2f seconds to cast that" % ability_timers[0].get_time_left())

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

func handle_abilities():
	# START ABILITY 1
	for fireball in fireballs:
		var bodies = fireball.get_colliding_bodies()
		for body in bodies:
			#todo: deal damage
			pass
		if bodies.size() > 0:
			if(fireballs.has(fireball)):
				fireballs.remove(fireballs.find(fireball))
			fireball.queue_free()
	
	# END ABILITY 1

func cooldown0():
	can_shoot_ability[0] = true

func cooldown1():
	can_shoot_ability[1] = true

func cooldown2():
	can_shoot_ability[2] = true

func cooldown3():
	can_shoot_ability[3] = true

func cooldown4():
	can_shoot_ability[4] = true

# Sets the correct animation based on the orientation
func handle_animations(direction, is_moving):
	var sum = direction.x + direction.y
	
	if is_moving > 0:
		# Moving
		if direction.x > 0:
			#0, 1, 2
			if sum == 0:
				sprite.set_animation("movetopright")
			elif sum == 1:
				sprite.set_animation("moveright")
			elif sum == 2:
				sprite.set_animation("movebotright")
			else:
				print("Moving player animation errors 1")
		elif direction.x < 0:
			#0, -1, -2
			if sum == 0:
				sprite.set_animation("movebotleft")
			elif sum == -1:
				sprite.set_animation("moveleft")
			elif sum == -2:
				sprite.set_animation("movetopleft")
			else:
				print("Moving player animation errors 2")
		else:
			#-1, 1
			if sum == -1:
				sprite.set_animation("movetop")
			elif sum == 1:
				sprite.set_animation("movebot")
			else:
				print("Moving player animation errors 3")
	else:
		# Idle
		if direction.x > 0:
			#0, 1, 2
			if sum == 0:
				sprite.set_animation("idletopright")
			elif sum == 1:
				sprite.set_animation("idleright")
			elif sum == 2:
				sprite.set_animation("idlebotright")
			else:
				print("Idle player animation errors 1")
		elif direction.x < 0:
			#0, -1, -2
			if sum == 0:
				sprite.set_animation("idlebotleft")
			elif sum == -1:
				sprite.set_animation("idleleft")
			elif sum == -2:
				sprite.set_animation("idletopleft")
			else:
				print("Idle player animation errors 2")
		else:
			#-1, 1, 0
			if sum == -1:
				sprite.set_animation("idletop")
			elif sum == 1:
				sprite.set_animation("idlebot")
			elif sum == 0:
				pass #no keys have been pressed yet
			else:
				print("Idle player animation errors 3")