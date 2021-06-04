extends WindowDialog

onready var vgrid: GridContainer = $VBoxContainer/ScrollContainer/VBoxContainer

var depot: Node2D

func _ready() -> void:
	
	EventBus.connect("depot_vehicle_list_updated", self, "_on_vehicle_list_updated")

func _on_vehicle_list_updated(updated_depot, vehicle_list) -> void:
	
	if depot != updated_depot:
		return
	
	for n in vgrid.get_children():
		n.queue_free()

	for 	vehicle in vehicle_list:

		var vimg: TextureRect = TextureRect.new()
		vimg.texture = vehicle.animated_sprite.frames.get_frame("default", 0)

		vgrid.add_child(vimg)
	
	

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
