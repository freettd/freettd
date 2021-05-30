extends CanvasLayer

signal command_issued(command)

onready var toolbar = $Toolbar
onready var statusbar = $Statusbar

onready var windows_manager = $Windows
onready var startmneu = $StartMenu

onready var startmenu = $StartMenu

func _ready() -> void:
	
	EventBus.connect("command_issued", self, "_process_command")
		
		
func _process_command(command) -> void:
	
	match (command.opcode):
		
		Global.OpCode.NEW_GAME:
			set_game_ui()
			
		Global.OpCode.NEW_SCENARIO:
			set_scenario_ui()
			
		Global.OpCode.EXIT_GAME:
			set_start_ui()

func set_start_ui() -> void:
	toolbar.hide()
	statusbar.hide()
	startmenu.show()
	
func set_game_ui() -> void:
	toolbar.show()
	statusbar.show()
	startmenu.hide()

func set_scenario_ui() -> void:
	toolbar.show()
	statusbar.hide()
	startmenu.hide()
