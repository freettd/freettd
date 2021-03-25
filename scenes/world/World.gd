extends Node

# game signals
signal newgame_progress(status, percentage)
signal savegame_progress(status, percentage)
signal loadgame_progress(status, percentage)

signal hq_selected(company)
signal local_company_updated(company)

# error signal
signal error(msg)

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
var company_register: Array = []


################################################################################
## NEW WORLD

func new_scenario(command: Dictionary) -> void:
	
	editor_mode = EditorMode.EDIT
	
	var map_size: Vector2 = Vector2(command.parameters.x, command.parameters.y)
	
	# Terrain
	terrain.new_world({
		map_size = map_size
	})	
	

func new_game(command: Dictionary) -> void:
	
	editor_mode = EditorMode.PLAY
	
	emit_signal("newgame_progress", "creating new game", 0)
	var map_size: Vector2 = Vector2(command.parameters.x, command.parameters.y)
	
	# Terrain
	terrain.new_world({
		map_size = map_size
	})
	
	# New Company
	local_company = Company.new()
	local_company.company_id = company_register.size()
	local_company.company_type = Company.CompanyType.LOCAL
	company_register.append(local_company)
	
	# complete
	emit_signal("newgame_progress", "new game complete", 100)

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

# process local commands from UI
func process_local_command(command: Dictionary) -> void:
	
	# local command is for local company
	command.company = local_company
	
	var opcode: int = command.opcode
	
	if Global.SelectorConfig.has(opcode):
		selector.activate(command, Global.SelectorConfig.get(opcode))
	
# process commands after tiles selected
func _on_Selector_tile_selected(command: Dictionary):
	
	var tm_resources: Dictionary = Resources.tilemaps
	var bld_resources: Dictionary = Resources.buildings
	var dimension: Vector2 = command.selection.dimension
	
	var expense: int = 0
	
	match command.opcode:
		
		Global.OpCode.BUILD_ROAD:
			var cost: int = tm_resources.road.cost * (dimension.x * dimension.y)		
			terrain.build_road(command, roadnav)
			expense = cost
		
		Global.OpCode.BUILD_COMPANY_HQ:
			var cost: int = bld_resources.company_hq_large.cost
			world_objects.add_hq("company_hq_large", command.selection.position, local_company)
			expense = cost
			
	# if in play mode then update company
	if editor_mode == EditorMode.PLAY:
		local_company.add_expense(expense)
		emit_signal("local_company_updated", local_company)


func _on_Selector_error(msg):
	emit_signal("error", msg)


func _on_WorldObjects_hq_selected(company: Company):
	if not selector.visible:
		emit_signal("hq_selected", company)
		

################################################################################
## SAVE & LOAD GAME
	
func load_game(filename: String = AUTOSAVE_FILENAME) -> void:
	
	# start loading game
	emit_signal("loadgame_progress", "loading", 0)
	var file: File = File.new()
	file.open_compressed("user://" + filename, File.READ, File.COMPRESSION_ZSTD)
	
	# read
	var data = str2var(file.get_as_text())
	
	print(data.keys())
	
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




