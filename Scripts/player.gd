extends KinematicBody2D

const MAX_SPEED = 80
var direction = Vector2()

onready var sprite = get_node("AnimatedSprite")

var animation_names = []

func _ready():
	set_fixed_process(true)
		

func _fixed_process(delta):
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


# Cancer function because switch statements don't exist
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