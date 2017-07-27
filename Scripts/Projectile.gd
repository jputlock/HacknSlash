extends Node2D

onready var sample_player = get_tree().get_root().get_node("Game/GUI Layer/SamplePlayer")

var damage = 0
var origin_pos = Vector2()
var should_die = false
var ability_range
var ability_name = get_name()

func init(damage, ability_range, sound_effect):
	self.damage = damage
	self.ability_range = ability_range
	add_to_group("Projectile")
	origin_pos = get_global_pos()
	sample_player.play(sound_effect, 1)
	set_fixed_process(true)

func _fixed_process(delta):
	var dist_from_origin = get_global_pos().distance_to(origin_pos)
	var percent_left = (ability_range - dist_from_origin) / ability_range
	if percent_left < 0.2:
		get_node("Sprite").set_opacity(6 * percent_left)
	var bodies = get_colliding_bodies()
	for body in bodies:
		if body.is_in_group("Enemy"):
			body.edit_health(-damage)
		if not body.is_in_group("Projectile"):
			should_die = true
	if should_die or dist_from_origin > ability_range:
		die()

func die():
	queue_free()
