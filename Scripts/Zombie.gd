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
		queue_free()

func edit_health(health_to_add):
	health += health_to_add
	if health > MAX_HEALTH:
		health = MAX_HEALTH
	if health < 0:
		health = 0