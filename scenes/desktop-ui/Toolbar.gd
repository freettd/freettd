extends PanelContainer

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
	popup.add_item("New Game", Command.Action.NEW_GAME)
	popup.add_item("New Scenario", Command.Action.NEW_SCENARIO)
	popup.add_separator()
	popup.add_item("Load", Command.Action.LOAD_GAME)
	popup.add_separator()
	popup.add_item("Save", Command.Action.SAVE_GAME)
	popup.add_separator()
	popup.add_item("Exit Game", Command.Action.EXIT_GAME)
	popup.add_item("Exit App", Command.Action.EXIT_APP)
	popup.connect("id_pressed", self, "_on_item_pressed")

	# Company Menu
	popup = options_button.get_popup()
	popup.add_item("Transparent Trees", Command.Action.CONFIG_TRANSPARENT_TREES)
	popup.connect("id_pressed", self, "_on_item_pressed")	
	
	# Company Menu
	popup = company_button.get_popup()
	popup.add_item("Build HQ", Command.Action.BUILD_COMPANY_HQ)
	popup.connect("id_pressed", self, "_on_item_pressed")	

	# Construction Menu
	popup = construct_button.get_popup()
	popup.add_item("Bulldoze", Command.Action.CLEAR_LAND)
	popup.add_separator()
	popup.add_item("Plant Tree", Command.Action.PLANT_TREE)
	popup.connect("id_pressed", self, "_on_item_pressed")	
	
	# Road Menu
	popup = road_button.get_popup()
	popup.add_item("Build Road", Command.Action.BUILD_ROAD)
	popup.add_item("Build Depot", Command.Action.BUILD_ROAD_DEPOT)	
	popup.add_separator()
	popup.add_item("Build Passenger Terminal", Command.Action.BUILD_PAX_TERMINAL)
	popup.add_item("Build Passenger Stop", Command.Action.BUILD_PAX_STOP)
	popup.add_separator()
	popup.add_item("Build Cargo Terminal", Command.Action.BUILD_TRUCK_TERMINAL)
	popup.add_item("Build Cargo Stop", Command.Action.BUILD_TRUCK_STOP)
	popup.add_separator()
	popup.add_item("View Vehicles", Command.Action.BUILD_ROAD)
	popup.connect("id_pressed", self, "_on_item_pressed")	
	
	# Road Menu
	popup = rail_button.get_popup()
	popup.add_item("Build Rail", Command.Action.BUILD_RAIL)
	popup.connect("id_pressed", self, "_on_item_pressed")	
	
	# Help Menu
	popup = help_button.get_popup()
	popup.add_item("Query", Command.Action.TILE_QUERY)
	popup.connect("id_pressed", self, "_on_item_pressed")	

func _on_item_pressed(id: int) -> void:
	EventBus.emit_signal("command_issued", {
		action = id
	})
