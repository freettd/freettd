# inspired by https://github.com/PetePete1984/SuperTilemap

extends Node2D

const MAX_HEIGHT: int = 8
const NOISE_OCTAVES: int = 4
const NOISE_PERIOD: float = 20.0 # wavey
const NOISE_PERSISTENCE: float = 0.5 # smoothness
const NOISE_FREQUENCY: float = 0.05
const SEALEVEL: int = 1

const TILES_PER_TYPE: int = 19

# array of tilemaps
var levels: Array = []

# array of cells
var celldata: Dictionary = {}

var map_size: Vector2

enum TileType {
	grass1,
	road_grass,
	water
}

## NEW TERRAIN

func new_terrain(p: Dictionary, map_size: Vector2) -> void:

	self.map_size = map_size

	if not levels.empty():
		levels.clear()

	for height in MAX_HEIGHT:
		var instance = TileMap.new()
		instance.set_mode(TileMap.MODE_ISOMETRIC)
		instance.set_cell_size(p.cell_size)
		instance.set_tileset(load(p.tileset))
		instance.set_position(p.height_offset * height)

		add_child(instance)
		levels.append(instance)

	generate_heightmap(map_size)

## GENERATE TERRAIN

const FlatTile: int = 0
const CornerWest: int = 8
const CornerSouth: int = 4
const CornerEast: int = 2
const CornerNorth: int = 1
const SteepSlope: int = 16

var tid: int = 0

const neighbours: Dictionary = {
	Vector2.UP+Vector2.LEFT: CornerNorth,
	Vector2.UP: CornerNorth|CornerEast,
	Vector2.UP+Vector2.RIGHT: CornerEast,
	Vector2.RIGHT: CornerSouth|CornerEast,
	Vector2.DOWN+Vector2.RIGHT: CornerSouth,
	Vector2.DOWN: CornerSouth|CornerWest,
	Vector2.DOWN+Vector2.LEFT: CornerWest,
	Vector2.LEFT: CornerNorth|CornerWest
}

func generate_flatland(map_size: Vector2 = Vector2(64, 64)) -> void:

	self.map_size = map_size

	for x in map_size.x:
		for y in map_size.y:
			var v = Vector2(x, y)
			celldata[v] = {}
			_set_tile(v, 1, TileType.water, 0)

func generate_heightmap(map_size: Vector2 = Vector2(64, 64)) -> void:

	self.map_size = map_size
	var min_noise: float = 0.0
	var max_noise: float = 0.0

	# randomize the randomizer
	randomize()

	# Make noise
	var noise: OpenSimplexNoise = OpenSimplexNoise.new()
	noise.seed = randi()
	noise.octaves = NOISE_OCTAVES
	noise.period = NOISE_PERIOD
	noise.persistence = NOISE_PERSISTENCE

	# Generate Noise
	for x in map_size.x:
		for y in map_size.y:
			var noise_value: float = noise.get_noise_2d(NOISE_FREQUENCY * x, NOISE_FREQUENCY * y)
			min_noise = min(min_noise, noise_value)
			max_noise = max(max_noise, noise_value)

			celldata[Vector2(x, y)] = {
				noise = noise_value
			}

	# Smooth Noise
	for cellv in celldata:
		var gridval: int = int(round(range_lerp(celldata[cellv].noise, min_noise, max_noise, 0, levels.size()-1)))
		celldata[cellv].noise = max(0, gridval - SEALEVEL)

	# Set Tile Images
	for cellv in celldata:
		
		var cdata = celldata[cellv]
		
		# adjust tiles
		var image_id = _get_tile_alignment(cellv)
		
		# Surrounded by 4 points so raise level
		if _contains_bits(image_id, CornerNorth|CornerEast|CornerSouth|CornerWest):
			cdata.noise += 1
			image_id = 0
		
		#  if level 0 then its a shore tile
		if cdata.noise == 0:
			_set_tile(cellv, 0, TileType.water, image_id)
		else:
			_set_tile(cellv, cdata.noise, TileType.grass1, image_id)

# calculate tile direction based on neighbouring tiles
func _get_tile_alignment(cellv: Vector2) -> int:

	var cdata: Dictionary = celldata[cellv]
	var cell_height: int = celldata[cellv].noise
	var corner_bits: int = 0

	# Check neighbours for raised cornes
	for neighbour in neighbours:
		var ncell = cellv + neighbour
		if is_valid_tile(ncell):
			var nval = celldata[ncell].noise
			if nval == cell_height + 1:
				corner_bits |= neighbours[neighbour]
			elif nval == cell_height + 2:
				corner_bits |= SteepSlope

	# Map to steep slope images
	if _contains_bits(corner_bits, SteepSlope):

		if _contains_bits(corner_bits, CornerEast|CornerNorth|CornerWest):
			corner_bits = 15
			cell_height += 1
		elif _contains_bits(corner_bits, CornerSouth|CornerEast|CornerNorth):
			corner_bits = 16
		elif _contains_bits(corner_bits, CornerWest|CornerSouth|CornerEast):
			corner_bits = 17
		elif _contains_bits(corner_bits, CornerNorth|CornerSouth|CornerWest):
			corner_bits = 18
		else:
			print_debug("something went horrible wrong here")

	return corner_bits

# set tile
func _set_tile(cellv: Vector2, height: int, tiletype_id: int, image_id: int = 0) -> void:

	# shortcut to cell data
	var cdata: Dictionary = celldata[cellv]

	# calculate index in tileset
	var tileset_idx: int = (tiletype_id * TILES_PER_TYPE) + image_id

	# tiles with north corners do not align correctly so we use an offset
	if _contains_bits(image_id, CornerNorth):
		height += 1

	# set tile on height level
	var level: TileMap = levels[height]
	level.set_cellv(cellv, tileset_idx)

	# generate unique number for tile
	tid = tid + 1

	# save tile data
	cdata.id = tid
	cdata.tiletype = tiletype_id
	cdata.tileset_idx = tileset_idx
	cdata.height = height
	cdata.corners = image_id

# Check if bist are set
func _contains_bits(bitmask: int, mask: int) -> bool:
	return (bitmask & mask) == mask

# Is tile valid
func is_valid_tile(cellv: Vector2) -> bool:
	return cellv.x >= 0 and cellv.x < map_size.x and cellv.y >= 0 and cellv.y < map_size.y
