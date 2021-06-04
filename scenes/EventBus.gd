extends Node

signal command_issued(command)

# World Objects
signal hq_selected(hq)
signal depot_selected(depot)

# Company
signal local_company_financials_update()

signal vehicle_in_depot(vehicle, depot)
signal depot_vehicle_list_updated(depot, vehicle_list)

func _ready() -> void:
#	connect("command_issued", self, "_command_spy")
	pass
	
func _command_spy(command) -> void:
	prints("command spy:", command)
