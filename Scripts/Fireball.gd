extends RigidBody2D

onready var sample_player = get_node("SamplePlayer")

func _ready():
	sample_player.play("fireball")
	set_fixed_process(true)

func _fixed_process(delta):
	var bodies = get_colliding_bodies()
	for body in bodies:
		if body.is_in_group("Enemy"):
			body.edit_health(-10)
	if bodies.size() > 0:
		queue_free()
