extends Node

# Default autosave filename
const AUTOSAVE_FILENAME: String = "autosave.sav"

enum EditorMode { PLAY, EDIT, VIEW }
var editor_mode: int = EditorMode.VIEW


# World components
onready var camera = $MainCamera
onready var terrain = $Terrain
onready var selector = $Selector
onready var world_objects = $WorldObjects

# Navigation Objects
var roadnav: AStar2D = AStar2D.new()

# Company Register
var local_company: Company

# regsiters
var company_register: Array = []

func _ready() -> void:
	
	EventBus.connect("command_issued", self, "_process_local_command")


func _process_local_command(cmd) -> void:
	
	match (cmd.action):
	
		Command.Action.NEW_GAME:
			new_game(cmd.parameters)
			
		Command.Action.NEW_SCENARIO:
			new_editor(cmd.parameters)
			
		Command.Action.SAVE_GAME:
			save_game()
			
		Command.Action.LOAD_GAME:
			load_game()
			
		Command.Action.EXIT_GAME:
			reset()
			
		Command.Action.CONFIG_TRANSPARENT_TREES:
			world_objects.set_trees_transparent()
			
		Command.Action.BUY_VEHICLE:
			world_objects.add_vehicle_in_depot("modern_bus", cmd.parameters.depot, roadnav)
			
		Command.Action.SELL_ALL_VEHICLES_IN_DEPOT:
			for vehicle in cmd.parameters.depot.vehicle_list:
				vehicle.queue_free()
				
			cmd.parameters.depot.vehicle_list.clear()

	
	if Command.SelectorConfig.has(cmd.action):
		selector.activate(cmd, Command.SelectorConfig.get(cmd.action))


################################################################################
## NEW WORLD

func new_game(parameters: Dictionary) -> void:
	new_world(EditorMode.PLAY, parameters)
	
func new_editor(parameters: Dictionary) -> void:
	new_world(EditorMode.EDIT, parameters)

func new_world(editor_mode: int, parameters: Dictionary) -> void:
	
	self.editor_mode = editor_mode
	
	var mapsize = parameters.map_size
	
	emit_signal("newworld_progress", "creating new world", 0)
	
	# Terrain
	terrain.new_world(parameters)
	
	# New Company
	if editor_mode == EditorMode.PLAY:
		local_company = Company.new()
		local_company.company_id = company_register.size()
		local_company.company_type = Company.CompanyType.LOCAL
		company_register.append(local_company)
	
	# place random trees	 across map
	emit_signal("newworld_progress", "planting trees", 50)
#	world_objects.plant_tree(Rect2(0, 0, mapsize.x, mapsize.y), { 
#		min_density = 0, 
#		max_density = 3, 
#		start_frame = -1,
#		scattered = 8
#	})
		
	# complete
	emit_signal("newworld_progress", "new world complete", 100)

func reset() -> void:
	
	# deactivate selector
	selector.deactivate()
	
	# remove companies
	company_register.clear()
	
	# clear terrain
	terrain.reset()
	
	# remove world objects
	world_objects.reset()

################################################################################
## LOCAL COMMANDS
	
# process commands after tiles selected
func _on_Selector_tile_selected(command: Dictionary) -> void:
	
	var tm_resources: Dictionary = Resources.tilemaps
	var bld_resources: Dictionary = Resources.buildings
	var tree_res: Dictionary = Resources.trees

	var dimension: Vector2 = command.selection.dimension
	var box: Rect2 = command.selection.box
	
	var expense: int = 0
	
	match command.action:
		
		Command.Action.BUILD_ROAD:
			record_expense(tm_resources.road.cost, box.get_area())
			world_objects.clear_land(command.selection.box)	
			terrain.build_road(command, roadnav)
		
		Command.Action.BUILD_COMPANY_HQ:
			record_expense(bld_resources.company_hq.cost)
			world_objects.add_object("company_hq", command.selection.position, local_company)

		Command.Action.BUILD_ROAD_DEPOT:
			record_expense(bld_resources.road_depot.cost)
			world_objects.add_object("road_depot", command.selection.position, local_company)

		Command.Action.CLEAR_LAND:
			record_expense(10, box.get_area())
			world_objects.clear_land(command.selection.box)

		Command.Action.PLANT_TREE:
			record_expense(tree_res.cost, box.get_area())
			world_objects.plant_tree(command.selection.box)


################################################################################
## Economy

func record_expense(expense: int, qty = 1) -> void:
	if editor_mode == EditorMode.PLAY:
		local_company.add_expense(expense)
		emit_signal("local_company_updated", local_company)


################################################################################
## SAVE & LOAD GAME
	
func load_game(filename: String = AUTOSAVE_FILENAME) -> void:
	
	# start loading game
	emit_signal("loadgame_progress", "loading", 0)
	var file: File = File.new()
	file.open_compressed("user://" + filename, File.READ, File.COMPRESSION_ZSTD)
	
	# read
	var data = str2var(file.get_as_text())
	
	# load company data
	for company_data in data.companies:
		
		var new_company = Company.new()
		new_company.load_data(company_data)
		company_register.append(new_company)
		
		if new_company.company_type == Company.CompanyType.LOCAL:
			local_company = new_company
			emit_signal("local_company_updated", local_company)
		
	# load terrain data
	terrain.load_world(data.tilemap)
	
	# load world objects
	world_objects.load_data(data.world_objects, company_register)
	
	# load camera
	camera.position = data.camera.position
	camera.zoom = data.camera.zoom
	
	# signal completion
	file.close()	
	emit_signal("loadgame_progress", "loaded", 100)	


func save_game(filename: String = AUTOSAVE_FILENAME) -> void:
	
	# start saving game
	emit_signal("savegame_progress", "saving", 0)
	var file: File = File.new()
	file.open_compressed("user://" + filename, File.WRITE, File.COMPRESSION_ZSTD)
	
	# data structure
	var data: Dictionary = {}
	
	# tiemap
	data.tilemap = terrain.get_save_data()
	
	# company data
	data.companies = []
	for company in company_register:
		data.companies.append(company.get_save_data())
		
	# game objects
	data.world_objects = world_objects.get_save_data()
	
	# camera
	data.camera = {
		position = camera.position,
		zoom = camera.zoom
	}	
	
	# write file
	file.store_string(var2str(data))
	
	# signal completion
	file.close()	
	emit_signal("savegame_progress", "saved", 100)
