extends Node

var windows: Dictionary = {}

onready var company_profile_window = load("res://scenes/desktop-ui/windows/CompanyWindow.tscn")

func show_error(msg) -> void:
	pass
	
func show_company_profile_window(company) -> void:
	_show_window(company, company_profile_window)
	
func _show_window(window_id, window_scene) -> void:	

	if not windows.has(window_id):
		var wnd = window_scene.instance()
		add_child(wnd)
		windows[window_id] = wnd
		
	# show window
	windows.get(window_id).show()