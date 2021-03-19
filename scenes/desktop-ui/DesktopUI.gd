extends CanvasLayer

signal command_issued(command)

onready var toolbar = $Toolbar
onready var statusbar = $Statusbar

onready var windows_manager = $Windows
onready var startmneu = $StartMenu

onready var startmenu = $StartMenu

func _on_Toolbar_command_issued(command: Dictionary) -> void:
	emit_signal("command_issued", command)
	
func update_local_company_info(company: Company) -> void:
	statusbar.update_balance(company.bank_balance)

func show_company_profile(company: Company) -> void:
	windows_manager.show_company_profile_window(company)

func show_error(msg: String) -> void:
	windows_manager.show_error(msg)

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

func _on_StartMenu_command_issued(command):
	emit_signal("command_issued", command)
