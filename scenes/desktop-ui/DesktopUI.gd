extends CanvasLayer

signal command_issued(command)

onready var windows_manager = $Windows
onready var statusbar = $Statusbar

func _on_Toolbar_command_issued(command: Dictionary) -> void:
	emit_signal("command_issued", command)
	
func update_local_company_info(company: Company) -> void:
	statusbar.update_balance(company.bank_balance)

func show_company_profile(company: Company) -> void:
	windows_manager.show_company_profile_window(company)

func show_error(msg: String) -> void:
	windows_manager.show_error(msg)
