extends Node2D

func _ready() -> void:

	EventBus.connect("command_issued", self, "_on_command_issued")

	$DesktopUI.set_start_ui()


# UI EVENTS

func _on_command_issued(command: Dictionary) -> void:

	# special op codes
	match command.opcode:

		Command.ID.EXIT_APP:
			get_tree().quit()

