extends TileMap

var tile_size = get_cell_size()
var tile_offset = Vector2(0, tile_size.y / 2)

enum ENTITY_TYPES { PLAYER, OBSTACLE, COLLECTIBLE } 

func _ready():
	pass