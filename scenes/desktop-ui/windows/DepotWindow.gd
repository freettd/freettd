extends WindowDialog

onready var vehicle_list = $VBoxContainer/ItemList

var src: Node2D

func _process(delta) -> void:
	
	set_title("Depot (" + str(src.vehicle_list.size()) + ")")

func _on_BuyButton_pressed():
	EventBus.emit_signal("command_issued", {
		action = Command.Action.BUY_VEHICLE,
		parameters = {
			vehicle_id = 1,
			depot = src
		}
	})


func _on_SellAllButton_pressed():
	EventBus.emit_signal("command_issued", {
		action = Command.Action.SELL_ALL_VEHICLES_IN_DEPOT,
		parameters = {
			depot = src
		}
	})
