extends CanvasLayer

signal command_issued(command)

func _on_Toolbar_command_issued(command: Dictionary) -> void:
	emit_signal("command_issued", command)
