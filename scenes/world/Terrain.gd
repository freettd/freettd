extends "res://scenes/world/LayedTilemap.gd"

const NOISE_OCTAVES: int = 4
const NOISE_PERIOD: float = 20.0 # wavey
const NOISE_PERSISTENCE: float = 0.5 # smoothness
const NOISE_FREQUENCY: float = 0.05
const SEALEVEL: int = 1

const TILES_PER_TYPE: int = 19

# array of cells

var world_config: Dictionary
var tilemap_config: Dictionary

var celldata = {}

## NEW TERRAIN

func new_world(wcfg: Dictionary, tcfg: Dictionary) -> void:

	self.world_config = wcfg	
	self.tilemap_config = tcfg

	# Build terrain
	generate_heightmap()


## GENERATE TERRAIN

const MASK_FLAT_TILE: int = 0
const MASK_NORTH_CORNER: int = 1
const MASK_EAST_CORNER: int = 2
const MASK_SOUTH_CORNER: int = 4
const MASK_WEST_CORNER: int = 8

const MASK_NORTH_STEEP: int = 15
const MASK_EAST_STEEP: int = 16
const MASK_SOUTH_STEEP: int = 17
const MASK_WEST_STEEP: int = 18

var tid: int = 0

const NEIGHBOURS: Dictionary = {
	Vector2.UP+Vector2.LEFT: MASK_NORTH_CORNER,
	Vector2.UP: MASK_NORTH_CORNER|MASK_EAST_CORNER,
	Vector2.UP+Vector2.RIGHT: MASK_EAST_CORNER,
	Vector2.RIGHT: MASK_SOUTH_CORNER|MASK_EAST_CORNER,
	Vector2.DOWN+Vector2.RIGHT: MASK_SOUTH_CORNER,
	Vector2.DOWN: MASK_SOUTH_CORNER|MASK_WEST_CORNER,
	Vector2.DOWN+Vector2.LEFT: MASK_WEST_CORNER,
	Vector2.LEFT: MASK_NORTH_CORNER|MASK_WEST_CORNER
}

func generate_flatland() -> void:

	var map_size: Vector2 = world_config.map_size
	var tindex: Dictionary = tilemap_config.tindex

	# loop through each tile
	for x in map_size.x:
		for y in map_size.y:
			
			var v = Vector2(x, y)
			celldata[v] = {}
			_set_tile(v, 1, tindex.grass, 0)

func generate_heightmap() -> void:

	# inspired by https://github.com/PetePete1984/SuperTilemap

	var map_size: Vector2 = world_config.map_size
	var tindex: Dictionary = tilemap_config.tindex

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
		var gridval: int = int(round(range_lerp(celldata[cellv].noise, min_noise, max_noise, 0, max_height)))
		celldata[cellv].noise = max(0, gridval - SEALEVEL)

	# Set Tile Images
	for cellv in celldata:
		
		var cdata = celldata[cellv]
		
		# adjust tiles
		var image_id = _get_tile_alignment(cellv)
		
		# Surrounded by 4 points so raise level
		if _contains_bits(image_id, MASK_NORTH_CORNER|MASK_EAST_CORNER|MASK_SOUTH_CORNER|MASK_WEST_CORNER):
			cdata.noise += 1
			image_id = 0
		
		#  if level 0 then its a shore tile
		if cdata.noise == 0:
			_set_tile(cellv, 0, tindex.water, image_id)
		else:
			_set_tile(cellv, cdata.noise, tindex.grass, image_id)

# calculate tile direction based on neighbouring tiles
func _get_tile_alignment(cellv: Vector2) -> int:

	var cdata: Dictionary = celldata[cellv]
	var cell_height: int = celldata[cellv].noise
	var corner_bits: int = 0
	var steeptile: bool = false

	# Check neighbours for raised cornes
	for neighbour in NEIGHBOURS:
		var ncell = cellv + neighbour
		
		# Skip if not a valid cell location
		if not is_valid_tile(ncell):
			continue
			
		# Get noise
		var nval = celldata[ncell].noise
		
		# One level above
		if nval == cell_height + 1:
			corner_bits |= NEIGHBOURS[neighbour]
			
		# Two levels above
		elif nval == cell_height + 2:
			steeptile = true

	# Map to steep slope images
	if steeptile:

		if _contains_bits(corner_bits, MASK_EAST_CORNER|MASK_NORTH_CORNER|MASK_WEST_CORNER):
			corner_bits = MASK_NORTH_STEEP
			cell_height += 1
		elif _contains_bits(corner_bits, MASK_SOUTH_CORNER|MASK_EAST_CORNER|MASK_NORTH_CORNER):
			corner_bits = MASK_EAST_STEEP
		elif _contains_bits(corner_bits, MASK_WEST_CORNER|MASK_SOUTH_CORNER|MASK_EAST_CORNER):
			corner_bits = MASK_SOUTH_STEEP
		elif _contains_bits(corner_bits, MASK_NORTH_CORNER|MASK_SOUTH_CORNER|MASK_WEST_CORNER):
			corner_bits = MASK_WEST_STEEP
		else:
			print_debug("something went horrible wrong here")

	return corner_bits

# set tile
func _set_tile(cellv: Vector2, height: int, tiletype_id: int, image_id: int = 0) -> void:

	# shortcut to cell data
	var cdata: Dictionary = celldata[cellv]

	# calculate index in tileset
	var tileset_idx: int = tiletype_id + image_id

	# tiles with north corners do not align correctly so we use an offset
	if _contains_bits(image_id, MASK_NORTH_CORNER):
		height += 1

	# set tile on height level
	set_cellv_height(cellv, height)
	set_cellv(cellv, tileset_idx)

	# generate unique number for tile
	tid = tid + 1

	# save tile data
	cdata.id = tid

# Check if bist are set
func _contains_bits(bitmask: int, mask: int) -> bool:
	return (bitmask & mask) == mask

# Is tile valid
func is_valid_tile(cellv: Vector2) -> bool:
	var map_size: Vector2 = world_config.map_size
	return cellv.x >= 0 and cellv.x < map_size.x and cellv.y >= 0 and cellv.y < map_size.y
