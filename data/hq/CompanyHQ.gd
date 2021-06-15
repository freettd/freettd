extends Node2D

var level: int = 1
onready var current_sprite: Node2D = $SimpleHQ

var company

func upgrade() -> void:
	
	level += 1
	current_sprite.hide()
	
	if level > 4:
		level = 4
	
	match level:
		
		1: current_sprite = $SimpleHQ
		2: current_sprite = $SmallHQ	
		3: current_sprite = $MediumHQ
		4: current_sprite = $LargeHQ
			
	current_sprite.show()

func _on_Area2D_input_event(viewport, event, shape_idx):
	if Input.is_mouse_button_pressed(BUTTON_LEFT):
		EventBus.emit_signal("hq_selected", self)
