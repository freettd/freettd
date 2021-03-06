extends PanelContainer

signal command_issued(command)

onready var game_button = $HBoxContainer/GameButton
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
	popup.add_item("Exit", Global.OpCode.EXIT_GAME)
	popup.connect("id_pressed", self, "_on_item_pressed")

	# Construction Menu
	popup = construct_button.get_popup()
	popup.add_item("Bulldoze", Global.OpCode.CLEAR_LAND)
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
