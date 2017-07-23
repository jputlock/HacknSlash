extends Node2D

var MAX_HEALTH = 10
var health = MAX_HEALTH

func init(max_hp):
	MAX_HEALTH = max_hp
	health = MAX_HEALTH
	set_fixed_process(true)

func _fixed_process(delta):
	if not is_alive():
		death_protocol()

func is_alive():
	return health > 0

func edit_health(health_to_add):
	health += health_to_add
	if health > MAX_HEALTH:
		health = MAX_HEALTH
	if health < 0:
		health = 0

# Write this in the extended class
func death_protocol():
	pass