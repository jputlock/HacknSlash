extends RigidBody2D

onready var animator = get_node("AnimationPlayer")

var MAX_HEALTH = 20
var health = 20

func _ready():
	set_fixed_process(true)
	animator.set_current_animation("idlebot")
	health = MAX_HEALTH

func _fixed_process(delta):
	if health == 0:
		if animator.get_current_animation() != "deathbot":
			animator.set_current_animation("deathbot")
			#get_node("Shadow").queue_free()
		elif animator.get_current_animation() == "deathbot":
			if not animator.is_playing():
				queue_free()
			else:
				pass
		else:
			print("wtf is going on in Zombie")

func is_alive():
	return health > 0

func edit_health(health_to_add):
	health += health_to_add
	if health > MAX_HEALTH:
		health = MAX_HEALTH
	if health < 0:
		health = 0