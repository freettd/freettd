extends WindowDialog

export var vehicle_item: Resource

onready var vlist = $TabContainer/Vehicles/ScrollContainer/VehicleList
onready var buylist: ItemList = $TabContainer/Buy/VehicleBuyList

var depot: Node2D

func _ready() -> void:
	EventBus.connect("depot_vehicle_list_updated", self, "_on_vehicle_list_updated")
	visible = true
	
func set_depot(depot) -> void:
	
	self.depot = depot

	var vehicles = Dataset.vehicles
	
	for key in vehicles:
		if vehicles[key].transport_type == depot.transport_type:
			buylist.add_item(vehicles[key].name)

func _on_vehicle_list_updated(updated_depot) -> void:
	
	if depot != updated_depot:
		return
		
	var vehicle_list: Array = updated_depot.vehicle_list
	
	for n in vlist.get_children():
		n.queue_free()

	for 	vehicle in vehicle_list:
		
		var vitem = vehicle_item.instance()
		vlist.add_child(vitem)

		vitem.set_vehicle(vehicle)


func _on_BuyButton_pressed():
	EventBus.emit_signal("command_issued", {
		action = Command.Action.BUY_VEHICLE,
		parameters = {
			vehicle_id = 1,
			depot = depot
		}
	})


func _on_SellAllButton_pressed():
	EventBus.emit_signal("command_issued", {
		action = Command.Action.SELL_ALL_VEHICLES_IN_DEPOT,
		parameters = {
			depot = depot
		}
	})

func _on_VehicleBuyList_item_selected(index):
	print(index)
