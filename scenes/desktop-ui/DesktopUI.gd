extends CanvasLayer

signal command_issued(command)

onready var windows_manager = $Windows

func _on_Toolbar_command_issued(command: Dictionary) -> void:
	emit_signal("command_issued", command)

func show_company_profile(company: Company) -> void:
	windows_manager.show_company_profile_window(company)

func show_error(msg: String) -> void:
	windows_manager.show_error(msg)
