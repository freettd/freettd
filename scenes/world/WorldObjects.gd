extends YSort

# Signal when company HQ is selected
signal hq_selected(company)

export (NodePath) var world_terrain
onready var terrain: Node2D = get_node(world_terrain)


# add company HQ to the world
func add_hq(building: Dictionary, cellv: Vector2, company: Company) -> void:
	
	# add scene to world
	var scene: Node2D = _add_object(building, cellv)
	
	# connect signal	
	scene.connect("selected", self, "_on_hq_selected", [company])
	
	
# when the company HQ is selected
func _on_hq_selected(company: Company) -> void:
	emit_signal("hq_selected", company)
	
	
# add object to world
func _add_object(building: Dictionary, cellv: Vector2) -> Node2D:
	
	# create scene
	var scene: Node2D = load(building.src).instance()
	
	# set position
	scene.position = terrain.map_to_world(cellv)
	
	# add scene to world
	add_child(scene)
	
	# return scene
	return scene
