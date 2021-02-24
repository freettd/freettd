extends Node2D

func _on_DesktopUI_command_issued(command: Dictionary) -> void:
	
	match command.opcode:
		
		Global.OpCode.EXIT_GAME:
			get_tree().quit()
	
