extends WindowDialog

signal command_issued(command)

onready var x_param: SpinBox = $VBoxContainer/HBoxContainer/XParam
onready var y_param: SpinBox = $VBoxContainer/HBoxContainer/YParam
onready var land_toggle: CheckBox = $VBoxContainer/GenerateLandToggle

func _on_NewGameButton_pressed():
	emit_signal("command_issued", {
		opcode = Global.OpCode.NEW_GAME,
		parameters = {
			generate_land = land_toggle.is_pressed(),
			map_size = Vector2(x_param.value, y_param.value)
		}
	})


func _on_NewScenarioButton_pressed():
	emit_signal("command_issued", {
		opcode = Global.OpCode.NEW_SCENARIO,
		parameters = {
			generate_land = land_toggle.is_pressed(),
			map_size = Vector2(x_param.value, y_param.value)
		}
	})	
