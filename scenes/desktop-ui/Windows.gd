extends Node

var windows: Dictionary = {}

export var company_profile_window: Resource
export var depot_window: Resource

func _ready() -> void:
	
	EventBus.connect("command_issued", self, "_on_command_received")
	EventBus.connect("depot_selected", self, "show_depot_window")
	EventBus.connect("hq_selected", self, "_on_hq_selected")
	
func _on_hq_selected(hq) -> void:
	show_company_profile_window(hq)
	pass

func show_error(msg) -> void:
	pass
	
func show_company_profile_window(hq) -> void:
	_show_window(hq, company_profile_window)
	
func show_depot_window(depot) -> void:
	_show_window(depot, depot_window)

func _on_command_received(command) -> void:
	
	match (command.action):
		
		Command.Action.SHOW_ROAD_VEHICLE_LIST:
			print(get_tree().get_nodes_in_group("road_vehicle"))
	
func _show_window(src, window_scene) -> void:	

	if not windows.has(src):
		var wnd = window_scene.instance()
		wnd.src = src
		add_child(wnd)
		windows[src] = wnd
		
	# show window
	var wnd = windows.get(src)
	
	
	wnd.raise()
	wnd.show()
