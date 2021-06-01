extends WindowDialog

onready var vehicle_list = $VBoxContainer/ItemList

var depot: Node2D

func _on_BuyButton_pressed():
	EventBus.emit_signal("command_issued", {
		action = Command.Action.BUY_VEHICLE,
		vehicle_id = 1,
		depot = depot
	})
