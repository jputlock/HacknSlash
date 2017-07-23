extends Sprite

func _ready():
	pass

func init(closest_enemy):
	var enemy_sprite = closest_enemy.get_node("Sprite")
	var width_of_shadow = get_texture().get_width() / get_hframes() * get_scale().x
	var width_of_enemy = enemy_sprite.get_texture().get_width() / enemy_sprite.get_hframes() * enemy_sprite.get_scale().x
	var xScale = width_of_shadow / width_of_enemy
	
	set_scale(Vector2(xScale, xScale))
	set_offset(Vector2(0, enemy_sprite.get_texture().get_height() / enemy_sprite.get_vframes() / 3.5))