extends Node2D

export var tileset: TileSet
export var cell_size: Vector2 = Vector2(128, 64)
export var max_height: int = 8
export var height_offset: Vector2 = Vector2(0, -16)

var layers: Array = []
var heightmap: Dictionary = {}

func _ready() -> void:

	# Create tilemap for each level
	for height in max_height:

		var instance = TileMap.new()
		instance.set_mode(TileMap.MODE_ISOMETRIC)
		instance.set_cell_size(cell_size)
		instance.set_tileset(tileset)
		instance.set_position(height_offset * height)

		add_child(instance)
		layers.append(instance)

func set_tiledata(data) -> void:
	pass

func clear() -> void:
	for layer in layers:
		layer.clear()

func world_to_map(world_pos: Vector2) -> Vector2:

	# loop through until we find a match
	for layer in layers:

		# isometric transform
		var local_pos: Vector2 = layer.global_transform.xform_inv(world_pos)

		# convert pointer to tile
		var coords: Vector2 = layer.world_to_map(local_pos)

		# if there is an image then we must have a tile
		if layer.get_cell(coords.x, coords.y) != -1:
			return coords

	# this should never happen
	return Vector2.INF

func map_to_world(cellv: Vector2) -> Vector2:
	var layer = layers[heightmap[cellv]]
	return layer.global_transform.xform(layer.map_to_world(cellv))

func set_cellv_height(cellv: Vector2, height: int) -> void:
	heightmap[cellv] = height

func set_cellv(cellv: Vector2, tileset_idx) -> void:
	var layer = layers[heightmap[cellv]]
	layer.set_cellv(cellv, tileset_idx)

func get_cellv_height(cellv: Vector2) -> int:
	return heightmap[cellv]
