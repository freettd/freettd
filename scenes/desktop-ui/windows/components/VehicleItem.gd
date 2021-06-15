extends HBoxContainer

signal selected()

onready var vrect = $TextureRect
var vehicle

func set_vehicle(vehicle) -> void:
	self.vehicle = vehicle
	vrect.texture = vehicle.animated_sprite.frames.get_frame("default", 0)


func _on_Area2D_input_event(viewport, event, shape_idx):
	print('rogi')
	if event is InputEventMouseButton and event.pressed and event.button_index == BUTTON_LEFT:
		EventBus.emit_signal("vehicle_selected", vehicle)


func _on_LinkButton_pressed():
	EventBus.emit_signal("vehicle_selected", vehicle)
