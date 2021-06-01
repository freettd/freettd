extends WindowDialog

onready var vehicle_list = $VBoxContainer/ItemList

var src: Node2D

func _on_BuyButton_pressed():
	EventBus.emit_signal("command_issued", {
		action = Command.Action.BUY_VEHICLE,
		parameters = {
			vehicle_id = 1,
			depot = src
		}
	})
