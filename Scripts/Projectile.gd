extends Node2D

onready var sample_player = get_tree().get_root().get_node("Game/GUI Layer/SamplePlayer")

var damage = 0
var burnout_time = 0
var timer = Timer.new()
var should_die = false
var ability_name = get_name()

func init(damage, burnout_time, sound_effect):
	self.damage = damage
	timer.connect("timeout", self, "die")
	timer.set_wait_time(burnout_time)
	timer.start()
	add_child(timer)
	sample_player.play(sound_effect, 1)
	set_fixed_process(true)

func _fixed_process(delta):
	var percent_time_left = timer.get_time_left() / timer.get_wait_time()
	if percent_time_left < 0.2:
		get_node("Sprite").set_opacity(percent_time_left + 10 * percent_time_left)
	var bodies = get_colliding_bodies()
	for body in bodies:
		print(body)
		if body.is_in_group("Enemy"):
			body.edit_health(-damage)
			should_die = true
	if should_die:
		die()

func die():
	queue_free()
