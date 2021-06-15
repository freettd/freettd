extends WindowDialog

var vehicle

onready var order_list: Tree = $TabContainer/Orders/OrderList

func _ready() -> void:
	visible = true
	
	var orders = [
		{ text = "station 1"},
		{ text = "station 2" },
		{ text = "station 3" }
	]
	
	var root = order_list.create_item()
	
	for order in orders:
		
		var order_item = order_list.create_item(root)
		order_item.set_text(0, order.text)
		order_item.set_text(1, "stop")
		order_item.set_text(2, "load")
	
