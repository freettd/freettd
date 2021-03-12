extends Node2D

signal selected()

func _on_Area2D_input_event(viewport, event, shape_idx):
	if Input.is_mouse_button_pressed(BUTTON_LEFT):
		emit_signal("selected")
