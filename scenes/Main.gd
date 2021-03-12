extends Node2D

onready var world = $World
onready var ui = $DesktopUI

func _ready() -> void:
	
	# Create New World
	world.new_world()
	

# UI EVENTS

func _on_DesktopUI_command_issued(command: Dictionary) -> void:
	
	# special op codes
	match command.opcode:
		
		Global.OpCode.EXIT_GAME:
			get_tree().quit()

	# Else send opcodes to World
	world.process_local_command(command)	


# WORLD EVENTS

func _on_World_hq_selected(company: Company):
	ui.show_company_profile(company)


func _on_World_error(msg):
	ui.show_error(msg)
