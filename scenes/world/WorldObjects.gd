extends YSort

# Signal when company HQ is selected
signal hq_selected(company)

export (NodePath) var world_terrain
onready var terrain: Node2D = get_node(world_terrain)

var objects: Array = []

## SAVE & LOAD

func get_save_data() -> Array:
	return objects
	
func load_data(data: Array) -> void:
	for scene in data:
		_add_object(scene.key, scene.cellv)



## ADD OBJECTS TO WORLD

# add company HQ to the world
func add_hq(res_key: String, cellv: Vector2, company: Company) -> void:
	
	# add scene to world
	var scene: Node2D = _add_object(res_key, cellv)
	
	# connect signal	
	scene.connect("selected", self, "_on_hq_selected", [company])
	
	
# when the company HQ is selected
func _on_hq_selected(company: Company) -> void:
	emit_signal("hq_selected", company)
	
	
# add object to world
func _add_object(res_key: String, cellv: Vector2) -> Node2D:
	
	# Get data for object
	var obj: Dictionary = Resources.buildings[res_key]
	
	# create scene
	var scene: Node2D = load(obj.src).instance()
	
	# set position
	scene.position = terrain.map_to_world(cellv)
	
	objects.append({
		key = res_key,
		cellv = cellv
	})
	
	# add scene to world
	add_child(scene)
	
	# return scene
	return scene
