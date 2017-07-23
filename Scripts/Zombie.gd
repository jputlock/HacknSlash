extends "res://Scripts/Entity.gd"

onready var animator = get_node("AnimationPlayer")

func _ready():
	init(20)
	animator.set_current_animation("idlebot")

func death_protocol():
	if animator.get_current_animation() != "deathbot":
		animator.set_current_animation("deathbot")
		get_node("CollisionShape2D").queue_free()
	elif animator.get_current_animation() == "deathbot":
		if not animator.is_playing():
			queue_free()
		else:
			pass
	else:
		print("Zombie animation error")
