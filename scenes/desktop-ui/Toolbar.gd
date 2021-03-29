extends PanelContainer

signal command_issued(command)

onready var game_button = $HBoxContainer/GameButton
onready var options_button = $HBoxContainer/OptionsButton

onready var company_button = $HBoxContainer/CompanyButton

onready var road_button = $HBoxContainer/RoadButton
onready var construct_button = $HBoxContainer/ConstructionButton
onready var rail_button = $HBoxContainer/RailButton
onready var air_button = $HBoxContainer/AirButton
onready var sea_button = $HBoxContainer/SeaButton

onready var help_button = $HBoxContainer/HelpButton

func _ready() -> void:
	
	var popup: PopupMenu
	
	# Game Menu
	popup = game_button.get_popup()
	popup.add_item("New Game", Global.OpCode.NEW_GAME)
	popup.add_item("New Scenario", Global.OpCode.NEW_SCENARIO)
	popup.add_separator()
	popup.add_item("Load", Global.OpCode.LOAD_GAME)
	popup.add_separator()
	popup.add_item("Save", Global.OpCode.SAVE_GAME)
	popup.add_separator()
	popup.add_item("Exit Game", Global.OpCode.EXIT_GAME)
	popup.add_item("Exit App", Global.OpCode.EXIT_APP)
	popup.connect("id_pressed", self, "_on_item_pressed")

	# Company Menu
	popup = options_button.get_popup()
	popup.add_item("Transparent Trees", Global.OpCode.CONFIG_TRANSPARENT_TREES)
	popup.connect("id_pressed", self, "_on_item_pressed")	
	
	# Company Menu
	popup = company_button.get_popup()
	popup.add_item("Build HQ", Global.OpCode.BUILD_COMPANY_HQ)
	popup.connect("id_pressed", self, "_on_item_pressed")	

	# Construction Menu
	popup = construct_button.get_popup()
	popup.add_item("Bulldoze", Global.OpCode.CLEAR_LAND)
	popup.add_separator()
	popup.add_item("Plant Tree", Global.OpCode.PLANT_TREE)
	popup.connect("id_pressed", self, "_on_item_pressed")	
	
	# Road Menu
	popup = road_button.get_popup()
	popup.add_item("Build Road", Global.OpCode.BUILD_ROAD)
	popup.connect("id_pressed", self, "_on_item_pressed")	
	
	# Road Menu
	popup = rail_button.get_popup()
	popup.add_item("Build Rail", Global.OpCode.BUILD_RAIL)
	popup.connect("id_pressed", self, "_on_item_pressed")	
	
	# Help Menu
	popup = help_button.get_popup()
	popup.add_item("Query", Global.OpCode.TILE_QUERY)
	popup.connect("id_pressed", self, "_on_item_pressed")	

func _on_item_pressed(id: int) -> void:
	emit_signal("command_issued", {
		opcode = id
	})
