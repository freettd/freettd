extends "res://scenes/world/LayeredTilemap.gd"

const ITEMS_PER_GROUP = 19

enum TileType {
	GROUND1, GROUND2, GROUND3, GROUND4,
	ROAD_GREEN, ROAD_SNOW, ROAD_FROST, ROAD_CONCRETE
	WATER
}

# array of cells

var config: Dictionary
var celldata = {}

################################################################################
## NEW TERRAIN

func new_world(parameters: Dictionary) -> void:

	config = parameters

	# Build terrain
	if parameters.generate_land:
		generate_heightmap()
	else:
		generate_flatland()
	
func reset() -> void:
	 
	# clear config
	config = {}
	
	# clear all tiles
	for cellv in celldata:
		set_cellv(cellv, -1)	

	# clear data
	celldata = {}
	
	
################################################################################
## Save & Load Data

func load_world(data: Dictionary) -> void:
	
	# get data from savefile
	config = data.config
	celldata = data.celldata
	
	# refresh map
	for cellv in celldata:
		_update_cell(cellv)
		
	
# return data to be saved
func get_save_data() -> Dictionary:
	return {
		config = config,
		celldata = celldata,
	}


################################################################################
## GENERATE TERRAIN

const NOISE_OCTAVES: int = 4
const NOISE_PERIOD: float = 20.0 # wavey
const NOISE_PERSISTENCE: float = 0.5 # smoothness
const NOISE_FREQUENCY: float = 0.05

const SEALEVEL: int = 1

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

# Directions
const DIRECTION: Dictionary = {
	NORTH_WEST = Vector2.LEFT,
	NORTH = Vector2.UP + Vector2.LEFT,
	NORTH_EAST = Vector2.UP,
	EAST = Vector2.UP + Vector2.RIGHT,
	SOUTH_EAST = Vector2.RIGHT,
	SOUTH = Vector2.DOWN + Vector2.RIGHT,
	SOUTH_WEST = Vector2.DOWN,
	WEST = Vector2.DOWN + Vector2.LEFT
}

const NEIGHBOURS: Dictionary = {
	DIRECTION.NORTH: MASK_NORTH_CORNER,
	DIRECTION.NORTH_EAST: MASK_NORTH_CORNER|MASK_EAST_CORNER,
	DIRECTION.EAST: MASK_EAST_CORNER,
	DIRECTION.SOUTH_EAST: MASK_SOUTH_CORNER|MASK_EAST_CORNER,
	DIRECTION.SOUTH: MASK_SOUTH_CORNER,
	DIRECTION.SOUTH_WEST: MASK_SOUTH_CORNER|MASK_WEST_CORNER,
	DIRECTION.WEST: MASK_WEST_CORNER,
	DIRECTION.NORTH_WEST: MASK_NORTH_CORNER|MASK_WEST_CORNER
}

func generate_flatland() -> void:

	var map_size: Vector2 = config.map_size

	# loop through each tile
	for x in map_size.x:
		for y in map_size.y:
			
			var cellv = Vector2(x, y)
			celldata[cellv] = {}
			_set_tile(cellv, 1, TileType.GROUND1, 0)

func generate_heightmap() -> void:

	# inspired by https://github.com/PetePete1984/SuperTilemap

	var map_size: Vector2 = config.map_size

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
			_set_tile(cellv, 0, TileType.WATER, image_id)
		else:
			_set_tile(cellv, cdata.noise, TileType.GROUND1, image_id)

# calculate tile direction based on neighbouring tiles
func _get_tile_alignment(cellv: Vector2) -> int:

	var cell_height: int = celldata[cellv].noise
	var corner_bits: int = 0
	var steeptile: bool = false

	# Check neighbours for raised cornes
	for neighbour in DIRECTION.values():
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
	var tileset_idx: int = get_tile_idx(tiletype_id, image_id)

	# tiles with north corners do not align correctly so we use an offset
	if _contains_bits(image_id, MASK_NORTH_CORNER):
		height += 1

	# generate unique number for tile
	tid = tid + 1

	# save tile data
	cdata.id = tid
	cdata.height = height
	cdata.corners = image_id
	cdata.tile_idx = tileset_idx
	
	_update_cell(cellv)
	
func _update_cell(cellv: Vector2) -> void:
	
	var cdata = celldata[cellv]
	
	set_cellv_height(cellv, cdata.height)
	set_cellv(cellv, cdata.tile_idx)	

# Check if bist are set
func _contains_bits(bitmask: int, mask: int) -> bool:
	return (bitmask & mask) == mask


################################################################################
## ROAD FUNCTIONS

const DEFAULT_NAV_WEIGHT: int = 1

const ROAD_CONNECTION_UP: int = 0x1
const ROAD_CONNECTION_RIGHT: int = 0x2
const ROAD_CONNECTION_DOWN: int = 0x4
const ROAD_CONNECTION_LEFT: int = 0x8

const ROAD_SLOPE_NORTHEAST = 16
const ROAD_SLOPE_SOUTHEAST = 17
const ROAD_SLOPE_SOUTHWEST = 18
const ROAD_SLOPE_NORTHWEST = 19

var connectors = {
	DIRECTION.NORTH_EAST: ROAD_CONNECTION_UP,
	DIRECTION.SOUTH_EAST : ROAD_CONNECTION_RIGHT,
	DIRECTION.SOUTH_WEST: ROAD_CONNECTION_DOWN,
	DIRECTION.NORTH_WEST: ROAD_CONNECTION_LEFT
}

func build_road(command: Dictionary, roadnav: AStar2D) -> void:

	# fixme?
	var box = Rect2(command.selection.position, command.selection.dimension)

	var start_tile: int = 0
	var end_tile: int = 0

	# this gives the road nice endings
	if box.size.x < box.size.y:
		start_tile = ROAD_CONNECTION_DOWN
		end_tile = ROAD_CONNECTION_UP
	else:
		start_tile = ROAD_CONNECTION_RIGHT
		end_tile = ROAD_CONNECTION_LEFT

	# default tile will have both connections
	var default_tile: int = start_tile|end_tile

	# variables used inside loop
	var road_tile: int
	var corners: int
	var cellv: Vector2
	var cdata: Dictionary
	var ntile: Dictionary

	# paint tiles
	for x in range(box.position.x, box.end.x ):
		for y in range(box.position.y, box.end.y):

			road_tile = 0

			# current tile
			cellv = Vector2(x, y)

			# Update Road Navigation
			cdata = celldata[cellv]
			corners = cdata.corners

			# add point to astar with default weight
			roadnav.add_point(cdata.id, cellv, DEFAULT_NAV_WEIGHT)

			# set termainals at each end
			if cellv == box.position:
				road_tile = start_tile
			elif cellv == box.end - Vector2.ONE:
				road_tile = end_tile
			else:
				road_tile = default_tile

			# slopes have no connections
			if corners != 0:

				var id = 0

				if _contains_bits(corners, NEIGHBOURS[DIRECTION.NORTH_EAST]):
					id = ROAD_SLOPE_NORTHEAST
				elif _contains_bits(corners, NEIGHBOURS[DIRECTION.SOUTH_EAST]):
					id = ROAD_SLOPE_SOUTHEAST
				elif _contains_bits(corners, NEIGHBOURS[DIRECTION.SOUTH_WEST]):
					id = ROAD_SLOPE_SOUTHWEST
				elif _contains_bits(corners, NEIGHBOURS[DIRECTION.NORTH_WEST]):
					id = ROAD_SLOPE_NORTHWEST

				road_tile = id
				
				# save connection data
				cdata.road_connections = road_tile

			# flat tiles have connections
			else:

				for n in connectors.keys():

					# skip if not on map
					if not is_valid_tile(cellv + n):
						continue

					# get neighbour tile properties
					ntile = celldata[cellv + n]

					# find incomming connections
					if ntile.has("road_connections") and _contains_bits(ntile.road_connections, connectors[-n]):

						# connect this current tile to neighbour
						roadnav.connect_points(cdata.id, ntile.id)

						# set bit
						road_tile |= connectors[n]
						
					# save connection data
					cdata.road_connections = road_tile
			
			# set road tile
			celldata[cellv].tile_idx = get_tile_idx(TileType.ROAD_GREEN, road_tile - 1)
			
			_update_cell(cellv)


################################################################################	
## HELPER TILE FUNCTIONS

func get_tile_idx(tiletype_id, image_id) -> int:
	return (tiletype_id * ITEMS_PER_GROUP) + image_id

# Is tile valid
func is_valid_tile(cellv: Vector2) -> bool:
	var map_size: Vector2 = config.map_size
	return cellv.x >= 0 and cellv.x < map_size.x and cellv.y >= 0 and cellv.y < map_size.y

func get_tile_data(cellv: Vector2) -> Dictionary:
	return celldata[cellv]

func is_water(cellv: Vector2) -> bool:
	return get_cellv_height(cellv) == 0

func is_slope(cellv: Vector2) -> bool:
	return celldata[cellv].corners != 0
	
func has_road(cellv: Vector2) -> bool:
	return celldata[cellv].get("road_connections", 0) != 0 
	
func is_free_land(cellv: Vector2) -> bool:
	return !has_road(cellv) && !is_water(cellv)
