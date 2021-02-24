extends Node2D

const MAX_HEIGHT: int = 8

# array of tilemaps
var levels: Array = []

func new_terrain(p: Dictionary) -> void:

	for height in MAX_HEIGHT:
		var instance = TileMap.new()
		instance.set_mode(TileMap.MODE_ISOMETRIC)
		instance.set_cell_size(p.cell_size)
		instance.set_tileset(load(p.tileset))
		instance.set_position(p.height_offset * height)

		add_child(instance)
		levels.append(instance)
