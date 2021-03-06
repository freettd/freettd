extends Node2D

onready var world = $World
onready var ui = $DesktopUI

func _ready() -> void:
	
	# todo: load this from external pck file
	var pck = preload("res://resources/zbase/Resource.gd").new()
	
	# Create New World
	world.new_world(pck)
	
	

func _on_DesktopUI_command_issued(command: Dictionary) -> void:
	
	# special op codes
	match command.opcode:
		
		Global.OpCode.EXIT_GAME:
			get_tree().quit()

	# Else send opcodes to World
	world.process_local_command(command)	
