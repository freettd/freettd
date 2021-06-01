extends Node

var windows: Dictionary = {}

export var company_profile_window: Resource
export var depot_window: Resource

func _ready() -> void:
	
	EventBus.connect("depot_selected", self, "show_depot_window")
	EventBus.connect("hq_selected", self, "_on_hq_selected")
	
func _on_hq_selected(hq) -> void:
	show_company_profile_window(hq)
	pass

func show_error(msg) -> void:
	pass
	
func show_company_profile_window(company) -> void:
	_show_window(company, company_profile_window)
	
func show_depot_window(depot) -> void:
	_show_window(depot, depot_window)

	
func _show_window(window_id, window_scene) -> void:	

	if not windows.has(window_id):
		var wnd = window_scene.instance()
		add_child(wnd)
		windows[window_id] = wnd
		
	# show window
	windows.get(window_id).show()
