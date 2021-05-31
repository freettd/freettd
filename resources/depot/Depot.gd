extends Node2D

export (String) var depot_suffix = "Depot"
export var can_rotate: bool = false

export var buy_road_vehicles: bool = false
export var buy_trains: bool = false
export var buy_ships: bool = false
export var buy_airplanes: bool = false
export var buy_helicopters: bool = false

onready var north_face = $NorthFace
onready var east_face = $EastFace
onready var south_face = $SouthFace
onready var west_face = $WestFace

var cellv: Vector2 = Vector2.ZERO
var current_face = 0
var faces: Array

var wid: int = -1
var depot_name: String = ""

func _ready() -> void:
	faces = [north_face, east_face, south_face, west_face]	
	
	faces[0].visible = true
	
	print(current_face)

func rotate_face() -> void:
	
	if not can_rotate:
		return
	
	faces[current_face].visible = false
	
	if current_face == 3:
		current_face = 0
	else:
		current_face += 1 
	
	faces[current_face].visible = true

func _on_Area2D_input_event(viewport, event, shape_idx):
	if event is InputEventMouseButton and event.pressed and event.button_index == BUTTON_LEFT:
		EventBus.emit_signal("depot_selected", self)

func set_default_name(name: String) -> void:
	depot_name = name + " " + depot_suffix
