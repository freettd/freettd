extends Node

signal command_issued(command)

# World Objects
signal hq_selected(hq)
signal depot_selected(depot)


func _ready() -> void:
	connect("command_issued", self, "_command_spy")
	
func _command_spy(command) -> void:
	prints("command spy:", command)
