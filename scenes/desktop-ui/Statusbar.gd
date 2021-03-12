extends PanelContainer

const current_symbol = "$"

onready var money_label = $HBoxContainer/MoneyLabel

func update_balance(value: int) -> void:
	
	if value >= 0:
		money_label.set("custom_colors/font_color", Color.white)
	else:
		money_label.set("custom_colors/font_color", Color.red)
	
	money_label.text = str(current_symbol, _comma_sep(abs(value)))


func _comma_sep(number: int) -> String:
	
	var string = str(number)
	var mod = string.length() % 3
	var res = ""

	for i in range(0, string.length()):
		if i != 0 && i % 3 == mod:
			res += ","
		res += string[i]

	return res
