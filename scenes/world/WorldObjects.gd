extends YSort

# Signal when company HQ is selected
signal hq_selected(company)

const COLOR_HALF_TRANSPARENT = Color( 1, 1, 1, 0.5 )
const COLOR_NO_TRANSPARENT = Color( 1, 1, 1, 1 )

export (NodePath) var world_terrain
onready var terrain: Node2D = get_node(world_terrain)

var company_register: Array

var rng = RandomNumberGenerator.new()

func _ready() -> void:
	rng.randomize()
	
	


################################################################################
## WORLD OBJECTS

var land_registry: Dictionary = {}

func _add_object_to_world(cellv: Vector2, object: Node2D) -> void:

	# create entry in land registry
	if not land_registry.has(cellv):
		land_registry[cellv] = []

	# add tree to registry
	land_registry[cellv].append(object)

	# add tree to world
	add_child(object)


func reset() -> void:

	# reset land registry
	land_registry = {}

	# free children
	for c in get_children():
		c.queue_free()


################################################################################
## SAVE & LOAD DATA

func get_save_data() -> Dictionary:
	return land_registry

func load_data(load_data: Dictionary, company_register: Array) -> void:
	pass

	# add HQs
#	for hq in load_data.hq:
#		_add_object(hq.key, hq.cellv, company_register[hq.company])

################################################################################
## CLEAR LAND

func clear_land(area: Rect2) -> void:

	# for each tile in selection
	for x in range(area.position.x, area.end.x):
		for y in range(area.position.y, area.end.y):

			# current tile
			var cellv = Vector2(x, y)

			# free each object on land
			for obj in land_registry.get(cellv, []):
				
				# may not be safe but it is the fastest
				obj.free()

			# remove entry from registry to save memory
			land_registry.erase(cellv)
	

################################################################################
## ADD OBJECTS TO WORLD

func add_vehicle_in_depot(key: String, depot: Node2D, nav: AStar2D) -> Node2D:
	
	# Get data for object
	var vdata: Dictionary = Resources.vehicles[key]
	
	# create scene
	var vehicle: Node2D = load(vdata.src).instance()
	
	# set position
	vehicle.position = terrain.map_to_world(depot.cellv)
	
	# add groups
	for tag in vdata.tags:
		vehicle.add_to_group(tag)
		
	# set navigation
	vehicle.navigation = nav
	
	# add vehicle to depot
	depot.vehicle_list.append(vehicle)
	
	# add scene to world
	add_child(vehicle)
	
	# return scene
	return vehicle

# add object to world
func add_object(res_key: String, cellv: Vector2, owner = null) -> Node2D:

	# Get data for object
	var obj: Dictionary = Resources.buildings[res_key]

	# create scene
	var scene: Node2D = load(obj.src).instance()

	# set position
	scene.cellv = cellv
	scene.position = terrain.map_to_world(cellv)

	# add scene to world
	_add_object_to_world(cellv, scene)

	# return scene
	return scene


################################################################################
## TREES

func plant_tree(area: Rect2, options: Dictionary = {}) -> void:
	
	# options with defaults
	var min_density: int = options.get("min_density", 1)
	var max_density: int = options.get("max_density", 1)
	var start_frame: int = options.get("start_frame", 0)
	var scattered: int = options.get("scattered", 10)

	var trees: Array = []
	for tree_scn in Resources.trees.src.temperate:
		trees.append(load(tree_scn))
	
	# loop vars
	var cellv: Vector2
	var offset: Vector2
	var tree: AnimatedSprite

	# for each tile in selection
	for x in range(area.position.x, area.end.x):
		for y in range(area.position.y, area.end.y):
			
			# scatter trees around area
			if rng.randi_range(1, 10) > scattered:
				continue
			
			# random density
			var density: int = rng.randi_range(min_density, max_density)
			
			for i in density:

				# current tile
				cellv = Vector2(x, y)
				
				# put tres on free land
				if not terrain.is_free_land(cellv):
					continue
				
				# generate random offset
				offset = Vector2(rng.randi_range(-24, 24), rng.randi_range(-24, 24))

				# create random tree
				tree = trees[rng.randi_range(0, trees.size()-1)].instance()

				# set random growth rate
				tree.frames.set_animation_speed("grow", rng.randf_range(0.01, 0.1))

				# set tree position inside tile
				tree.position = terrain.map_to_world(cellv) + offset
				
				# set random animation frame for growth
				if start_frame == -1:
					tree.set_frame(rng.randi_range(0, tree.frames.get_frame_count("grow")))
				else:
					tree.set_frame(start_frame)
				
				# play animation
				tree.play()
				
				tree.add_to_group("tree")

				# add object to world
				_add_object_to_world(cellv, tree)

func set_trees_transparent() -> void:
	
	for tree in get_tree().get_nodes_in_group("tree"):
		tree.modulate = COLOR_HALF_TRANSPARENT

