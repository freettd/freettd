extends WindowDialog

signal command_issued(command)

onready var x_param: SpinBox = $VBoxContainer/HBoxContainer/XParam
onready var y_param: SpinBox = $VBoxContainer/HBoxContainer/YParam

func _on_NewGameButton_pressed():
	emit_signal("command_issued", {
		opcode = Global.OpCode.NEW_GAME,
		parameters = {
			x = x_param.value,
			y = y_param.value
		}
	})


func _on_NewScenarioButton_pressed():
	emit_signal("command_issued", {
		opcode = Global.OpCode.NEW_SCENARIO,
		parameters = {
			x = x_param.value,
			y = y_param.value
		}
	})	
