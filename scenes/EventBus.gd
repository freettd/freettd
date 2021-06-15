extends Node

signal command_issued(command)

# Object Selection
signal hq_selected(hq)
signal depot_selected(depot)
signal vehicle_selected(vehicle)

# Company
signal local_company_financials_update()

signal vehicle_in_depot(vehicle, depot)
signal depot_vehicle_list_updated(depot)

func _ready() -> void:
#	connect("command_issued", self, "_command_spy")
	pass
	
func _command_spy(command) -> void:
	prints("command spy:", command)
