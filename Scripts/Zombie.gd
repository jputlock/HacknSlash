extends RigidBody2D

onready var animator = get_node("AnimationPlayer")
onready var enemy_health_bar = get_tree().get_root().get_node("Game/GUI Layer/GUI/TopBar/EnemyHealthBar")

var MAX_HEALTH = 20
var health = 20

func _ready():
	set_fixed_process(true)
	animator.set_current_animation("idlebot")
	health = MAX_HEALTH

func _fixed_process(delta):
	enemy_health_bar.set_max(MAX_HEALTH)
	enemy_health_bar.set_value(health)
	if health == 0:
		enemy_health_bar.hide()
		queue_free()

func edit_health(health_to_add):
	health += health_to_add
	if health > MAX_HEALTH:
		health = MAX_HEALTH
	if health < 0:
		health = 0