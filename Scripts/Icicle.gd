extends RigidBody2D

onready var sample_player = get_node("SamplePlayer")

var damage = 5

var burnout_time = 0.75
var timer = Timer.new()

func _ready():
	timer.connect("timeout", self, "die")
	timer.set_wait_time(burnout_time)
	timer.start()
	add_child(timer)
	sample_player.play("ice")
	set_fixed_process(true)

func _fixed_process(delta):
	var percent_time_left = timer.get_time_left() / timer.get_wait_time()
	if percent_time_left < 0.2:
		get_node("Sprite").set_opacity(percent_time_left + 10 * percent_time_left)
	var bodies = get_colliding_bodies()
	for body in bodies:
		if body.is_in_group("Enemy"):
			body.edit_health(-damage)
	if bodies.size() > 0:
		die()

func die():
	queue_free()