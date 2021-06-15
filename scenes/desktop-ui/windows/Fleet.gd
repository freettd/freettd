extends HBoxContainer

onready var vlist: ItemList = $VBoxContainer2/VehicleList

func _ready():
	
	var orders = [
		{ text = "Ungrouped"},
		{ text = "Group 2" },
		{ text = "Group 3" }
	]
	
	for order in orders:
		
		vlist.add_item(order.text)

	
