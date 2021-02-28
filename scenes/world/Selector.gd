extends "res://scenes/world/LayedTilemap.gd"

signal tile_selected(command)
signal error(msg)	

export (NodePath) var world_terrain
onready var terrain: Node2D = get_node(world_terrain)

# drag values
var drag_enabled: bool = false
var box: Rect2 = Rect2()
var current_tile: Vector2 = Vector2.INF
var selected_tile: Vector2 = Vector2.INF

# command config
var command: Dictionary
var config: Dictionary

var tparams: Dictionary

func new_world(world_cfg: Dictionary) -> void:
	self.tparams = world_cfg

func activate(command: Dictionary, config: Dictionary) -> void:
	self.command = command
	self.config = config
	visible = true	
		
func reset() -> void:
	visible = false

func _unhandled_input(event: InputEvent) -> void:

	# ignore if not visible
	if not visible:
		return

	# user pressed escape
	if Input.is_action_pressed("ui_cancel"):
		drag_enabled = false
		visible = false
		return
		
	# get current cell
	var cellv: Vector2 = world_to_map(get_global_mouse_position())
	
	if cellv != Vector2.INF:
		current_tile = cellv
		
	# user pressed left mouse button
	if event is InputEventMouseButton and event.button_index == BUTTON_LEFT:
		_handle_button_click(event)
		
	# user move mouse
	elif event is InputEventMouseMotion:
		_handle_mouse_move()

func _handle_button_click(event) -> void:
	
	if event.pressed:
		drag_enabled = true
		selected_tile = current_tile
		
	else:
		drag_enabled = false
		
		if not command.has("params"):
			command.params = {}
		
		command.params.box = box
		emit_signal("completed", command)
		
		clear()
			
		if not config.selector.repeat:
			visible = false

func _handle_mouse_move() -> void:

	# clear all squares
	clear()

	# if not in drag mode then draw single square
	if not drag_enabled:
		box = Rect2(current_tile, config.dimension)
	
	# boxed area
	else:
		box = Rect2(selected_tile, current_tile - selected_tile).abs()
		
		match config.selector.mode:
	
			Global.SelectMode.RAIL:
				pass
				
			# hprizontal or vertical line
			Global.SelectMode.ROAD:
				
				if (box.size.x < box.size.y):
					var start_tile = Vector2(selected_tile.x, box.position.y)
					var end_tile = Vector2(selected_tile.x, box.end.y)
					box = Rect2(start_tile, end_tile - start_tile)
					
				else:
					var start_tile = Vector2(box.position.x, selected_tile.y)
					var end_tile = Vector2(box.end.x, selected_tile.y)
					box = Rect2(start_tile, (end_tile - start_tile))

	# draw selection tiles
	for x in range(box.position.x, box.end.x + 1):
		for y in range(box.position.y, box.end.y + 1):
			
			var cellv = Vector2(x, y)
			
			if not terrain.is_valid_tile(cellv):
				continue
			
			# check if allowed on water
			if not config.selector.on_water and terrain.is_water(cellv):
				pass
				
			# check is allowed on slope
			if not config.selector.on_slope and terrain.is_slope(cellv):
				pass 	
			
			# get cell data
			var tile = terrain.get_celldata(cellv)
			
			# draw boxen
			set_cellv(cellv, tile.image_id)

