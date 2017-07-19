extends TextureProgress

onready var walls = get_tree().get_root().get_node("Game/World/Walls")
onready var shadow = preload("res://Nodes/Shadow.tscn")
var prev_closest_enemy = null
var shadow_instance = null

func _ready():
	set_fixed_process(true)

func _fixed_process(delta):
	var closest_enemy = get_closest_enemy()
	if closest_enemy == null:
		hide()
	elif closest_enemy == prev_closest_enemy:
		set_max(closest_enemy.MAX_HEALTH)
		set_value(closest_enemy.health)
	else:
		print("EnemyHealthBar on new enemy")
		if shadow_instance != null and shadow_instance.get_ref():
			shadow_instance.get_ref().queue_free()
		
		shadow_instance = weakref(shadow.instance())
		shadow_instance.get_ref().init(closest_enemy)
		closest_enemy.add_child(shadow_instance.get_ref())
		
		set_max(closest_enemy.MAX_HEALTH)
		set_value(closest_enemy.health)
		show()
	prev_closest_enemy = closest_enemy

func get_closest_enemy():
	var entities = walls.get_children()
	var player = null
	for entity in entities:
		if entity.get_name() == "Player":
			player = entity
	var dist = 100000
	var closest_enemy = null
	for entity in entities:
		if entity.is_in_group("Enemy"):
			if entity.get_pos().distance_to(player.get_pos()) < dist:
				dist = entity.get_pos().distance_to(player.get_pos())
				closest_enemy = entity
	return closest_enemy