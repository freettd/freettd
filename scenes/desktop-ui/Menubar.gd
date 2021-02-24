extends PanelContainer

signal command_issued(command)

onready var game_button = $HBoxContainer/GameButton
onready var road_button = $HBoxContainer/RoadButton
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

func _on_item_pressed(id: int) -> void:
	emit_signal("command_issued", {
		opcode = id
	})
