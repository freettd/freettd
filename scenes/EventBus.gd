extends Node

signal command_issued(command)

# World Objects
signal hq_selected(hq)

func _ready() -> void:
	EventBus.connect("command_issued", self, "_command_spy")
	
func _command_spy(command) -> void:
	prints("command spy:", command)
