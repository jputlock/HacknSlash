extends RigidBody2D

func _ready():
	set_fixed_process(true)

func _fixed_process(delta):
	var bodies = get_colliding_bodies()
	for body in bodies:
		if body.is_in_group("Enemy"):
			body.edit_health(-10)
	if bodies.size() > 0:
		queue_free()
